
import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late OpenVPN openvpn;
  VpnStatus status = VpnStatus.empty();
  VPNStage stage =VPNStage.disconnected;
  TextEditingController password = TextEditingController();
  TextEditingController username =  TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isSaved=true;
  String state = 'Disconnected';
  static const config = """client
dev tun
proto udp
remote 188.0.240.5 56552
tun-mtu 1500
resolv-retry infinite
nobind
persist-key
persist-tun
tls-client
remote-cert-tls server
cipher AES-128-GCM
auth SHA1
pull
auth-user-pass
verb 3
redirect-gateway

<ca>
-----BEGIN CERTIFICATE-----
MIIDDzCCAfegAwIBAgIIeJ/l9OeQMuIwDQYJKoZIhvcNAQELBQAwDTELMAkGA1UE
AwwCQ0EwHhcNMjMwODExMjA0OTQyWhcNMzMwODA4MjA0OTQyWjANMQswCQYDVQQD
DAJDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANfSjiX8kaAXUmGC
i2b/3EgI0orxCRbhIqJxXGtKaMaAKnWTMkyZoN2a50VTNeGJ2LhjJV5HLNsTCTEK
dRjrNnAhgwwxqyVybJWzgpKsPOKWbCeBXOTnX55MpFaLyT8I+nE9gts3Kb3YgCoU
Al344L5dHNX/ZaDcnEWAsYFvsIZEVDsvqTOeCD3v4Gz7Wjpllv04noUC8VtMDOSI
4OziUpkTydnv4jAg2begqoefy+W0jpkAyuoDa9U/fFNtPXIbX+6xfDOcrAJtUwy7
aKot9ow1Nkxi3xRlIZJFkx76yxH1fpHRXfNwpuccSES671Jo16GcXGgZ5z+MNX/K
IhUN8xkCAwEAAaNzMHEwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYw
HQYDVR0OBBYEFKssNuzR9Q6d8ly30GHMphlZEBcMMC8GA1UdHwQoMCYwJKAioCCG
Hmh0dHA6Ly8xODguMC4yNDAuNS9jcmwvODIxLmNybDANBgkqhkiG9w0BAQsFAAOC
AQEAZ54xAASwhvxdElNob0XFJlEtv65q44O66a7Qb6zze3Kvk5hUnSl4ybRZIIKX
rBrCwsBhO61uqLAssDyIxGhqk9MMRqCthnzX8XNlL1YVkVJFpc7T8j8GKq4p6iGo
A+nXG95L++olJJTm8+RSObSDWdn7Z+nyI2J01NSFgnf6n2Py4nqTuETL+YLoAhBT
CbKNLroFqPfBtEKUrQ6LEyF2hx4ulfCmwlhKc+1ycdk77WhloCbb7jWFAL3BqNC2
HXVS6MpvJKqpBInxf39NI7UnHzZCqBIw33VMex4smIL1OD3kP+1qHiTUrhqfN2hy
huChI+0zQ+w7jOprR2vlvU0Jmg==
-----END CERTIFICATE-----
</ca>
<cert>
-----BEGIN CERTIFICATE-----
MIIC9zCCAd+gAwIBAgIIGnRf+SF7tLcwDQYJKoZIhvcNAQELBQAwDTELMAkGA1UE
AwwCQ0EwHhcNMjMwODExMjA1MDQxWhcNMzMwODA4MjA1MDQxWjARMQ8wDQYDVQQD
DAZDTElFTlQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDicOwTSAda
dwpyw5MPD16o3TmQX7CmKEhLKto1Wzk5XKV7e62esuLV3w8tHSQ68WmJd9iNr1/4
b+M8EwNy2LgqfwSJnuGZedYblV4P8Up8L9o3HmU3x82xKtgwxoIp1OfQZLz7LhdV
KRADAdR1cVNuOfZbZ+UW2mYw55Ke6iz+oiCcnN9nfmxlUiIQUvksuQrgbyoDoqVP
dd227IiTjPcQJgfkm70LV/qcuL1l9xennoQWX8DVVOpI9o6YKfKNDttErseDEqdB
OZhiB568JOy17vtNiUkZgioN/ZDNvg8gB+DO6Tn+knitYvBxTVQYWlZbCyacpDT0
MouTYe8G4TQpAgMBAAGjVzBVMBMGA1UdJQQMMAoGCCsGAQUFBwMCMB0GA1UdDgQW
BBSZQTX+lu3sUGlDNS7zeDymWDzqBTAfBgNVHSMEGDAWgBSrLDbs0fUOnfJct9Bh
zKYZWRAXDDANBgkqhkiG9w0BAQsFAAOCAQEAD7/Jn083qwirvR2RisBts1EZBQRJ
DZNjcM55CdGjmKar0iRmShhJNbS2rgkTij91C1j8EFwK7K2pMSq+bh0c0kScofIw
7pjRHui5ZT9hCqHAGwdsVJOVxmPFibb9QRoAPN7C1Qmps0i1Xe9nabaTNF19dj4a
KwM+QG4hxxuN0rRv04jc3+glrXX1g1J43gYb6Ayn7u0HA5yhCwWT2k7+VUVJyY6b
QJ+2PEq/TgClBtWUfHWWKVXnra1gXzYReEw01yxpaAVY3E4I07Iz1AuO+wn99BJs
C9unIx2E6JWEYNCOv1JlWfCT/SKEbETZ0jrYOzu4/9sJ+oaDPCTjdDi0ag==
-----END CERTIFICATE-----
</cert>
<key>
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDicOwTSAdadwpy
w5MPD16o3TmQX7CmKEhLKto1Wzk5XKV7e62esuLV3w8tHSQ68WmJd9iNr1/4b+M8
EwNy2LgqfwSJnuGZedYblV4P8Up8L9o3HmU3x82xKtgwxoIp1OfQZLz7LhdVKRAD
AdR1cVNuOfZbZ+UW2mYw55Ke6iz+oiCcnN9nfmxlUiIQUvksuQrgbyoDoqVPdd22
7IiTjPcQJgfkm70LV/qcuL1l9xennoQWX8DVVOpI9o6YKfKNDttErseDEqdBOZhi
B568JOy17vtNiUkZgioN/ZDNvg8gB+DO6Tn+knitYvBxTVQYWlZbCyacpDT0MouT
Ye8G4TQpAgMBAAECggEAYDO/aDWqwhle/ADxAm3yNmW+ZgLxZrYoeJ7dE9wMxL0C
pSKXUZwIWPqqVO1TjiMwRjH/c7p1WHQYo1Ykme9O1ucdw2YXzH+BojhkPPuzPG2M
FOy57efaEJH2RUqg1CrazaNu0nvzd7+5SL3HSJn76xF/A7hxELN6xP4tQYyVzxu/
jmbF3ZT2igtTqM+5P/Ct51QadycaH5/mBjRn7LcfEXzr/xc3Nwr3go2kmUmqO3n9
b2gN6J8r4ZD3DDBHFbByyInv4bKJ4CafFsHtuc7gbSl2Ak9dr+6sXjABvRUKEBB5
FdzlI5j5BZdzb1Dq5bJ28JEvSCswyCZzuTY47hBoDQKBgQDy/lq6Gx/yzsV5kjsg
miu2A3zqsB98IuFgVzfTdjmUaQIekfkmvBx++U64uhw9x5zsnc52pjWMl7e8mqQE
IqXtySZbw8R9Ouix8Or+u+RgHXl+s/HHpxWIVEB6kTsIiozaVZFkzp4KsVf3Sh64
SPRUk/Lq09HisAGCCtbRwh6fSwKBgQDuj8F6BYS7VlY/lUJxcRzW3N9mlYEudqQM
xzQTk6qkbuz9HkVfE4gH0hxz6kX4auUbs4uRZdQa6BUQFCp/49ONCIXHOdEm0+9t
kZFju+nq1CZsIoep6KlBxiEWAXVJthtKrNBHj6+c6rUBWPBg/z4rv/ofi5Bl20Wf
65YLkRRt2wKBgDDQ5I0q0dpHq+hmdjZwgoOIY9oKE+kuYLSoEPEMeTjVd7WIgdNE
Sz0+/I+j4/SNW3s1oLq5XVynRiQ/tN+Xzlnc5TXeOGUoJoNI8QzH1nNwuG253MLN
UEgZFPMKph9rJizer9zenWVsh02IuG8xSNSM/Gosr6eo0ES9xLZTFy/NAoGACnvG
xNX5P0JMB/9HLDUMT2TlbFylkKUmEGmwoCudFBzLzVPHOKZjE/TnyzBAYupPpyf8
uib/ay9Hva0lMPmSEmCNgHPJ/SrTGr2K5hcb8HXiOl5KF+1hgsJyMcVeoh6elGmD
vaFS1lJ6IdUGuzx8Pu/wzfIUJmW8aYqwzVFS1IECgYEAn1MkiGMB9p1ceKZ0HHwL
NeGAAmOfgcrVf0dtqAL1Oxn+TQqo6aydxP1vdoD7wHB0KSULEWpt1ldhhS8BK5yX
MftQugjY3R1M76HNYhYXB4OdBOAOG8eOMjwFZBHe+PRD55Mp5ToNc4hfuf+s81CE
EyrbVftMrFXIL5HMrtsu2sA=
-----END PRIVATE KEY-----
</key>""";



  @override
  void initState() {
    openvpn = OpenVPN(onVpnStatusChanged: _onVpnStatusChanged, onVpnStageChanged: _onVpnStageChanged);
    openvpn.initialize(
        groupIdentifier: "GROUP_IDENTIFIER", ///Example 'group.com.laskarmedia.vpn'
        providerBundleIdentifier: "NETWORK_EXTENSION_IDENTIFIER", ///Example 'id.laskarmedia.openvpnFlutterExample.VPNExtension'
        localizedDescription: "LOCALIZED_DESCRIPTION" ///Example 'Laskarmedia VPN'
    );
    super.initState();
    _prefs.then((value) => {
        this.username.text = value.getString('username')??'' ,
        this.password.text = value.getString('password') ??''
   });
  }

  saveCreds(){
    if(isSaved){
      _prefs.then((value) => {
        value.setString('username', username.text.trim()),
        value.setString('password', password.text.trim())
      });
    }

  }

  void _onVpnStatusChanged(VpnStatus? vpnStatus){
    setState((){
      status = vpnStatus!;
    });
  }

  void _onVpnStageChanged(VPNStage? stage,String message){
    setState((){
      switch(stage){
        case VPNStage.connected:
          this.state = "CONNECTED";
          break;
        case VPNStage.disconnected:
          this.state = "DISCONNECTED";
          break;
        case VPNStage.disconnecting:
          this.state = "DISCONNECTING...";
          break;
        case VPNStage.connecting:
          this.state = "CONNECTING...";
          break;
        case VPNStage.authenticating:
          this.state = "AUTHENTICATING...";
          break;
        case VPNStage.authentication:
          this.state = "AUTHENTICATION";
          break;
        case VPNStage.error:
          this.state = "ERROR";
          break;
        case VPNStage.assign_ip:
          this.state = "GETTING IP...";
          break;
        default:
          this.state = "CONNECTING...";
          break;
      }
      this.stage = stage!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blueGrey,Colors.deepPurpleAccent],begin: Alignment.topLeft,end: Alignment.bottomRight)
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/crash.png',height: 150,width: 150,fit: BoxFit.contain,),
              Card(
                
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        controller: username,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),

                            ),
                            hintText: 'Username',
                            prefixIcon: Icon(Icons.person)
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      TextField(
                        controller: password,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),

                            ),
                            hintText: 'Password',

                            prefixIcon: Icon(Icons.vpn_key)
                        ),
                        obscureText: true,
                        textAlign: TextAlign.center,
                      ),
                      Row(children: [
                        Checkbox(value: isSaved, onChanged: (v)=>setState(() {
                          isSaved = !isSaved;
                        })),
                        Text('Save username and password?')
                      ],),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      MaterialButton(onPressed: ()=>{
                        if(stage == VPNStage.disconnected && username.text.length>0 && username.text.length>0){
                          saveCreds(),
                        openvpn.connect(config, 'sharif',username: username.text.trim(),password: password.text.trim(),bypassPackages: [],certIsRequired: true)
                      }else{
                        openvpn.disconnect()
                      }},
                        color: stage == VPNStage.disconnected ?Colors.green:Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(stage == VPNStage.disconnected ?'Connect':'Disconnect',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Icon(stage == VPNStage.disconnected ?Icons.vpn_key:Icons.vpn_lock,color: Colors.white,)
                        ],
                      ),
                      )

                    ],
                  ),
                )
              ),

/*              stage == VPNStage.connected ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('Connection time:',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                Text("${status.connectedOn?.hour}:${status.connectedOn?.minute}:${status.connectedOn?.second} ",style: new TextStyle(color: Colors.orange))
              ],):Padding(padding: EdgeInsets.zero),*/

              Text(
                '$state',style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),
              ),

            ],
          ),
        ),
      ),
/*      floatingActionButton: FloatingActionButton(
        backgroundColor: stage == VPNStage.disconnected ? Colors.red:Colors.green,
        onPressed: ()=>{
          if(stage == VPNStage.disconnected){
            openvpn.connect(config, 'sharif',username: 'user1',password: '123',bypassPackages: [],certIsRequired: true)
          }else{
            openvpn.disconnect()
          }
        },
        child: stage == VPNStage.disconnected ? Icon(Icons.vpn_key_off):Icon(Icons.vpn_key) ,
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {

    if(!isSaved){
      _prefs.then((value) => {
        value.setString('username', ''),
        value.setString('password', '')
      });
    }
    super.dispose();
  }
}
