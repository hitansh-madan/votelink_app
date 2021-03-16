import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:web3dart/web3dart.dart' as web3;
import 'package:http/http.dart';


class Vote extends StatefulWidget {
  @override
  _VoteState createState() => _VoteState();
  final String candidateId, electionId, constituencyId;
  final Map<String,dynamic> parties;
  Vote(this.constituencyId, this.candidateId, this.electionId, this.parties);
}

class _VoteState extends State<Vote> {

  final keyController = TextEditingController();
  final urlController = TextEditingController();
  Client httpClient;
  web3.Web3Client ethClient;

  @override
  void initState() {
    super.initState();
    httpClient = new Client();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: true,
        title: Text("Vote",style: TextStyle(color: Colors.black,),),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("elections")
              .doc(widget.electionId)
              .collection("constituencies")
              .doc(widget.constituencyId)
              .collection("candidates")
              .doc(widget.candidateId)
              .snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return Container();
            return Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40,),
                  Column(
                    children: <Widget>[
                      Center(
                        child: Hero(
                          child: CircleAvatar(radius: 70,),
                          tag: snapshot.data['name'],
                        ),
                      ),
                      Text(
                        snapshot.data['name'],
                        textScaleFactor: 2,
                      ),
                      Text(widget.parties[snapshot.data['partyId'].toString()],
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text("Enter your private key or scan the QR of your private key to cast your vote",textAlign: TextAlign.center,),
                        TextField(
                          controller: keyController,
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            )
                          ),
                        ),
                        Container(
                          width: 150,
                          child: RaisedButton(
                            color: Color(0xFFEEEEEE),
                            elevation: 0,
                            onPressed:()
                            {
                              setState(() async {
                                keyController.text=await scanner.scan();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.camera_alt),
                                Text("Scan QR"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text("Enter the RPC url(for demo only)",textAlign: TextAlign.center,),
                        TextField(
                          controller: urlController,
                          decoration: InputDecoration(
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(onPressed: (){castVote().then((value) => keyController.text="done bitch!!!");},
                    textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Text("Cast Vote",textScaleFactor: 1.3,),color: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                  ),
                ],
              ),
            );
          }),
    );
  }
  
  Future<String> castVote() async {
    // uint in smart contract means BigInt for us
    var _candidateId = BigInt.from(int.parse(widget.candidateId));
    ethClient= new web3.Web3Client(urlController.text.toString(), httpClient);
    // sendCoin transaction
    var response = await submit("vote", [_candidateId]);
    // hash of the transaction
    return response;
  }

  Future<web3.DeployedContract> loadContract() async {
    String abiCode = await rootBundle.loadString("assets/abi.json");
    String contractAddress = await getContractAddress();

    final contract = web3.DeployedContract(web3.ContractAbi.fromJson(abiCode, "Election"),
        web3.EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<String> getContractAddress() async
  {
    var _address;
    await FirebaseFirestore.instance.collection("elections").doc(widget.electionId).get().then((value) => _address=value.data()['address']);
    return _address;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    web3.EthPrivateKey credentials = web3.EthPrivateKey.fromHex("8fd036ced10be2c9351d9b201eb119cafb6366f76c588477e3513e2222bbd6a5");
    web3.DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);


    var result = await ethClient.sendTransaction(
      credentials,
      web3.Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: 1337
    );
    return result;
  }
}