Unit uUDPSuperComponents;

Interface

Uses
 Windows,      SysUtils,    Classes,      IdBaseComponent, IdUDPBase,
 IdHashMessageDigest,       IdUDPClient,  IdGlobal,        IdUDPServer,
 DateUtils,    StrUtils,    ZLibEX,       IdThreadSafe,    IdSocketHandle,
 SyncObjs,     Contnrs{$IFDEF MSWINDOWS},
                      {$IFDEF FMX}FMX.Forms
                      {$ELSE}VCL.Forms{$ENDIF},
                            Winsock2,     Rtti,
                            TypInfo   {$ENDIF},
 IdIcmpClient, IdCustomTransparentProxy,  IdSocks,         IdComponent,
 IdTCPClient,  IdTCPServer, uKBDynamic,   IdWinsock2,      IdContext,
 JDRMGraphics;

Const
 TSepValueMemString    = '\\';
 TQuotedValueMemString = '\"';

Type
 THeaderSizeData = LongInt;

Type
 TErrorType           = (etConnection,  etTimeOut, etLostConnection);
 TDataTypeDef         = (dtString     = 0, dtBroadcastString = 1,
                         dtBytes      = 2, dtBroadcastBytes  = 3,
                         dtDataStream = 4, dtRawString       = 5);
 TDataTransactionType = (dtt_Sync  = 1, dtt_Async            = 2,
                         dtt_Pulse = 3, dtt_direct           = 4);
 THostType            = (ht_Server = 0, ht_Client         = 1);
 TSendType            = (stNAT = 0,     stProxy = 1);
 TPackSendType        = (pstUDP = 0,    pstTCP  = 1);
 PSendType            = ^TSendType;
 PConnected           = ^Boolean;
 PSafeString          = ^String; //TIdThreadSafeString;
 PMyOnLineIP          = PString;
 PMyPort              = PWord;
 PUDPServer           = ^TIdUDPServer;
 PTCPServer           = ^TIdTCPServer;
 PObject              = ^TObject;
 TStringData          = Array of String;

Type
 TDataPack            = Packed Record
  InitBuffer,
  FinalBuffer,
  Compression         : Boolean;
  DataType,
  DataTransactionType,
  SendType            : Integer;
  PartsTotal,
  PackIndex,
  PackSize,
  ValueSize,
  TotalSize           : String;
  aValue              : TIdBytes;
  vHostSend,
  vHostDest,
  PackMD5,
  MD5                 : String;
  Function  HostSend  : String;
  Function  HostDest  : String;
  Function  PortSend  : Word;
  Function  PortDest  : Word;
  Function  GetValue  : String;
  Function  LoadFrom(AStream : TStream) : Boolean;
  Procedure SaveTo  (AStream : TStream);
  Procedure FromString(Const FromValue  : String);
  Function  ToString : String;
  Procedure New;
  Const
   cVersion        = 2;
   cDefaultOptions = [kdoAnsiStringCodePage, kdoUTF16ToUTF8];
End;

Const
 TPunchString         = '<|#PUNCH#|>';
 TPunchOKString       = '<|#PUNCHOK#|>';
 TReplyString         = '<|#REPLYOKPACK#|>';
 TConfirmPK           = '<|#PCKOK#|>';
 TGetIp               = '<|#HOSTIP#|>';
 TGetPort             = '<|#PORT#|>';
 TDelimiter           = '<|#CRLF#|>';
 TSendPing            = '<|#PING#|>';
 TReceivePing         = '<|#PINGOK#|>';
 TConnecClient        = '<|#CONNECTCLIENT#|>';
 TConnectPeer         = '<|#CONNECTPEER#|>';
 TDisconnecClient     = '<|#DISCONNECTCLIENT#|>';
 TInitPack            = '<|#INITPACK#|>';
 TFinalPack           = '<|#FINALPACK#|>';
 TInitBuffer          = '<|#INITBUFFER#|>';
 TFinalBuffer         = '<|#FINALBUFFER#|>';
 TMD5PackInit         = '<|#INITMD5#|>';
 TMD5PackFinal        = '<|#FINALMD5#|>';
 TCancelPack          = '<|#CANCELEVENT#|>';
 TCancelPackOK        = '<|#CANCELEVENTOK#|>';
 TCancelPackNO        = '<|#CANCELEVENTNO#|>';
 TRejectPack          = '<|#REJECTPACK#|>';
 TMyLocalIPInit       = '<|#LOCALIPINIT#|>';
 TMyLocalIPFinal      = '<|#LOCALIPFINAL#|>';
 TNoData              = '<|#NODATA#|>';
 TGetPeerInfo         = '<|#GETPEERINFO#|>';
 TPeerInfo            = '<|#PEERINFO#|>';
 TPeerNoData          = '<|#PEERNODATA#|>';
 TPeerConnect         = '<|#PEERCONNECT#|>';
 TOpenTransaction     = '<|#OPENTRANS#|>';
 TWelcomeMessage      = '<|#WELCOME#|>';
 TFormatPackData      = TInitPack        + '%s'   + TFinalPack;
 TMD5PackData         = TMD5PackInit     + '%s'   + TMD5PackFinal;
 TLocalIPPackData     = TMyLocalIPInit   + '%s:%d'   + TMyLocalIPFinal;
 TGetPeerInfoPackData = TGetPeerInfo     + TGetIp + '%s'       + TDelimiter + TGetPort + '%s' + TDelimiter;
 TPeerInfoPackData    = TPeerInfo        + TGetIp + '%s'       + TDelimiter + TGetPort + '%s' + TDelimiter +
                        TMyLocalIPInit   + '%s'   + TMyLocalIPFinal;
 TPeerNoDataPackData  = TPeerNoData      + TGetIp + '%s'       + TDelimiter + TGetPort + '%s' + TDelimiter;
 TConnectPeerInfo     = TConnectPeer     + '%s'   + TDelimiter + '%s';
 TOpenTransactionInfo = TOpenTransaction + '%s';
 TBufferInfo          = TInitBuffer      + '%s'   + TFinalBuffer;
 TTransportRTTI       = False;
 TIdAntiFreezeIDLE    = 250;
 TDelayThread         = 1;
 TReceiveTimeThread   = 1;
 TTimePunch           = 5;
 TPulseHits           = 0;
 TReceiveTime         = 3;
 TReceiveTimeOut      = 2;
 TRetryPacks          = 10;
 TSendPacksD          = 3;
 TPunchTimeOut        = 50;
 TThreadWaitDead      = 80;
 TPingTimeOut         = 1000;
 TReceiveTimeOutUDP   = 1000;
 TReceiveTimeOutUDPServer = 3000;
 MaxPunchs            = 3;
 MaxRetriesPeerCon    = 100;
 BUFFER_SIZE          = 1024 * 5;
 STREAM_SIZE          = 512  * 10; //Limite m�ximo de Stream
 szMyObject           = SizeOf(TDataPack) - SizeOf(String);
 szChar               = Sizeof(AnsiChar);
 TInitPort            = 32768;

Type
 TReceiveBuffer = Class
 Private
  vBuffer,
  vIdBuffer   : String;
  vPartsTotal,
  vBufferSize,
  vPackNo     : Integer;
  vLastCheck  : TDateTime;
 Public
  Property LastCheck  : TDateTime Read vLastCheck  Write vLastCheck;
  Property PackNo     : Integer   Read vPackNo     Write vPackNo;
  Property PartsTotal : Integer   Read vPartsTotal Write vPartsTotal;
  Property IdBuffer   : String    Read vIdBuffer   Write vIdBuffer;
  Property Buffer     : String    Read vBuffer     Write vBuffer;
  Property BufferSize : Integer   Read vBufferSize Write vBufferSize;
  Constructor Create;
End;

Type
 TPeerConnected = Class(TObject)
 Private
  TransactionOpen    : Boolean;
  vMaxRetriesPeerCon,
  OldLatency,
  RetriesTransaction : Integer;
  LastNegociateCheck : TDateTime;
 Public
  RemoteIP,
  LocalIP,
  SendMessage,
  WelcomeMessage  : String;
  LocalPort,
  Port,
  TCPPort         : Word;
  Latency         : Integer;
  LastCheck       : TDateTime;
  Connected       : Boolean;
  Punch           : Boolean;
  SendPeerConnect : Boolean;
  SocketHandle    : ^TIdSocketHandle;
  AContext        : TIdContext;
  Constructor Create;
End;

Type
 TEventExec               = Procedure                                   Of Object;
 TOnError                 = Procedure (ErrorType     : TErrorType)      Of Object;
 TOnGetData               = Procedure (Value         : String)          Of Object;
 POnGetData               = ^TOnGetData;
 TDataPeerInfo            = Procedure (Value         : String)          Of Object;
 TOnGetLongString         = Procedure (Value         : String)          Of Object;
 POnGetLongString         = ^TOnGetLongString;
 TOnConnected             = Procedure                                   Of Object;
 TOnTimer                 = Procedure                                   Of Object;
 TOnDataIn                = Procedure (Value         : TidBytes)        Of Object;
 TOnGetPeerInfo           = Procedure (PeerIP        : String;
                                       Port          : Word;
                                       PeerInfo      : TPeerConnected)  Of Object;
 TOnRead                  = Procedure (AThread       : TIdUDPListenerThread;
                                       Const AData   : String;
                                       ABinding      : TIdSocketHandle) Of Object;
 TOnClientConnected       = Procedure (ABinding      : TIdSocketHandle) Of Object;
 TOnClientDisconnected    = Procedure (ABinding      : TIdSocketHandle) Of Object;
 TOnPeerConnected         = Procedure (PeerConnected : TPeerConnected)  Of Object;
 TOnPeerRemoteConnect     = Procedure (OnlineMessage : String)          Of Object;
 TOnConnectionPeerTimeOut = Procedure (PeerIP,
                                       LocalIP       : String;
                                       Port          : Word)            Of Object;
 POnConnectionPeerTimeOut = ^TOnConnectionPeerTimeOut;

Type
 PReceiveBuffers = ^TReceiveBuffers;
 TReceiveBuffers = Class(TObjectList)
 Protected
  Function GetValue(PackID : String) : String;
 Private
  vBufferSize : Integer;
 Public
  Procedure  ClearList;
  Destructor Destroy;Override;
  Function   AddItem    (Var AItem   : TReceiveBuffer) : Boolean;
  Procedure  DeleteItem (aItemIndex  : Integer);Overload;
  Procedure  DeleteItem (PackID      : String); Overload;
  Property   Items[PackID : String]  : String  Read GetValue;
  Property   BufferSize              : Integer Read vBufferSize Write vBufferSize;
End;

Type
 PPeersConnected = ^TPeersConnected;
 TPeersConnected = Class(TObjectList)
 Protected
  Function GetValue(Index : Integer) : TPeerConnected;
 Public
  Procedure  ClearList;
  Destructor Destroy;Override;
  Function   AddPeer    (Var AItem   : TPeerConnected) : Boolean;
  Procedure  AddBind    (Ip          : String;
                         Port        : Integer;
                         Server      : TIdUDPServer);
  Procedure  DeleteItem (aItemIndex  : Integer);            Overload;
  Procedure  DeleteItem (Host        : String;
                         Port        : Word);Overload;
  Procedure  GetPeerInfo(Host        : String;
                         Port        : Word;
                         Var Result  : TPeerConnected);
  Property   Items[Index : Integer]  : TPeerConnected       Read GetValue;
End;

Type
 TDataValue = Class
  MasterPackID,
  PackID,
  LocalHost,
  HostSend,
  HostDest,
  MD5,
  Value               : String;
  aValue              : TIdBytes;
  PortSend,
  LocalPortSend,
  PortDest            : Word;
  PartsTotal,
  PackSize,
  ValueSize,
  Tries,
  PackIndex           : Integer;
  InitBuffer,
  FinalBuffer,
  Compression         : Boolean;
  DataType            : TDataTypeDef;
  HostType            : THostType;
  SendType            : TSendType;
  DataTransactionType : TDataTransactionType;
 Public
  Destructor Destroy;Override;
End;

Type
 TDataValueReceive = Class
  aValue : TIdBytes;
 Public
  Destructor Destroy;Override;
End;

Type
 TDataListReceive = Class(TObjectList)
 Protected
  Function GetValue(Index  : Integer) : TDataValueReceive;
 Public
  Procedure  ClearList;
  Destructor Destroy;Override;
  Procedure  AddItem   (Const AItem   : TDataValueReceive);
  Procedure  AddValue  (aValue        : TidBytes);
  Procedure  DeleteItem(aItemIndex    : Integer);
  Property   Items[Index : Integer]   : TDataValueReceive Read GetValue;
End;

Type
 TDataValueSend = Class
  Host         : String;
  Port         : Integer;
  aValue       : TIdBytes;
  PackSendType : TPackSendType;
 Public
  Destructor Destroy;Override;
End;

Type
 TDataListSend = Class(TObjectList)
 Protected
  Function GetValue(Index : Integer)  : TDataValueSend;
 Public
  Procedure  ClearList;
  Destructor Destroy;Override;
  Procedure  AddItem   (Const AItem   : TDataValueSend);
  Procedure  AddValue  (Host          : String;
                        Port          : Integer;
                        aValue        : TidBytes;
                        PackSendType  : TPackSendType = pstUDP);
  Procedure  DeleteItem(aItemIndex    : Integer);
  Property   Items[Index : Integer]   : TDataValueSend Read GetValue;
End;

Type
 TDataList = Class(TObjectList)
 Protected
  Function GetValue(Index  : Integer) : TDataValue;
 Public
  Procedure  ClearList;
  Destructor Destroy;Override;
  Procedure  AddItem   (Const AItem   : TDataValue);
  Procedure  DeleteItem(aItemIndex    : Integer); Overload;
  Procedure  DeleteItem(MD5           : String);  Overload;
  Function   GetBufferForID(Value     : String) : TDataValue;
  Property   Items[Index : Integer]   : TDataValue Read GetValue;
End;

Type
 TThreadConnection = Class(TThread)
 Protected
  vBufferID                : String;
  vProcessMessages,
  vKill                    : Boolean;
  vExecFunction            : TEventExec;
  FTerminateEvent          : TEvent;
  PeerConnectionOK         : PConnected;
  vClientUDP               : PObject;
  vOnConnectionPeerTimeOut : TOnConnectionPeerTimeOut;
  vPeersConnected          : PPeersConnected;
  PeerConnectionTimeOut    : Word;
  Procedure Kill;
  Procedure Execute; Override;
 Private

 Public
  Destructor  Destroy;Override;
  Constructor Create(BufferID                : String;
                     vPeerConnectionOK       : PConnected;
                     vPeerConnectionTimeOut  : Word;
                     ClientUDP               : PObject;
                     OnConnectionPeerTimeOut : TOnConnectionPeerTimeOut;
                     PeersConnected          : PPeersConnected);
End;

Type
 TProcessDataThread = Class(TThread)
 Protected
  vProcessMessages,
  vKill           : Boolean;
  vExecFunction   : TEventExec;
  FTerminateEvent : TEvent;
  vMilisExec      : Word;
  Procedure Kill;
  Procedure Execute; Override;
 Private
  vClientUDP      : TIdUDPClient;
 Public
  Property    ExecFunction       : TEventExec Read vExecFunction Write vExecFunction;
  Destructor  Destroy;Override;
  Constructor Create(ClientUDP   : TIdUDPClient);
End;

Type
 TUDPClient = Class(TThread)
 Protected
  vHostIP        : String;
  vHostPort      : Word;
  vTries         : Integer;
  vLastTimer     : TDateTime;
  vOnPunch,
  vSyncTimerInterface,
  vNoPunch,
  vRequestAlive  : Boolean;
  vOpenTrans     : PConnected;
  Procedure Execute; Override;
 Private
  vUDPSuperClient      : TObject;
  vOnTranslate,
  OpenTrans,
  OnPunch              : Boolean;
  ReceiveBuffers       : TReceiveBuffers;
  ProcessDataThread    : TProcessDataThread;
  DataListReceive      : TDataListReceive;
  vDataReceived        : Integer;
  vInternalTimer       : PConnected;
  vOnGet,
  vKill                : Boolean;
  vListSend            : TDataList;
  vClientUDPReceive    : TIdUDPServer;
  vClientUDPSend,
  vClientUDP           : TIdUDPClient;
  vTCPClient           : TIdTCPClient;
  vSelf                : TObject;
  vAtualStreamB        : TIdBytes;
  OldMD5,
  vLastMD5,
  vWelcome             : String;
  vTimeOut,
  vRetryPacks          : Word;
  vOnError             : TOnError;
  vOnGetData           : TOnGetData;
  vOnConnected         : TOnConnected;
  vOnTimer             : TOnTimer;
  vDataPeerInfo        : TDataPeerInfo;
  vOnPeerConnected     : TOnPeerConnected;
  vOnPeerRemoteConnect : TOnPeerRemoteConnect;
  vOnGetLongString     : TOnGetLongString;
  vOnBinaryIn,
  vOnDataIn            : TOnDataIn;
  vIPVersion           : TIdIPVersion;
  vConnected           : PConnected;
  vPeersConnected      : PPeersConnected;
  vBufferCapture       : PSafeString;
  vSendType            : PSendType;
  vMyOnLineIP          : PMyOnLineIP;
  vMilisTimer,
  vBufferSize,
  vMyPort,
  vMyOnlinePort        : PMyPort;
  vCodificao           : IIdTextEncoding;
  vTransparentProxy    : TIdCustomTransparentProxy;
  FTerminateEvent      : TEvent;
  PeerConnectionOK     : PConnected;
  PServer              : PUDPServer;
  vTCPPort             : Word;
  Procedure GetData;
  Procedure SendPing;
  Procedure GetPeer             (Var Result  : TPeerConnected;
                                 Host        : String;
                                 Port        : Integer);
  Function  NegociateTransaction(Client      : TIdUDPClient;
                                 Value       : TDataValue) : Boolean;
  Procedure UDPRead             (AThread     : TIdUDPListenerThread;
                                 Const AData : TIdBytes;
                                 ABinding    : TIdSocketHandle);
  Procedure UDPReceive          (Value       : String);Overload;
  Procedure UDPReceive          (Value       : TIdBytes);Overload;
 Public
  Procedure   Kill;
  Function    AddPack(Peer                   : String;
                      Port                   : Word;
                      Value                  : tIdBytes;
                      Compression            : Boolean              = False;
                      SendHost               : THostType            = ht_Client;
                      DataType               : TDataTypeDef         = dtString;
                      DataSize               : Integer              = -1;
                      DataTransactionType    : TDataTransactionType = dtt_Sync;
                      PackIndex              : Integer              = 0;
                      ValueSize              : Integer              = 0;
                      InitBuffer             : Boolean              = False;
                      FinalBuffer            : Boolean              = False;
                      InitBufferID           : String               = '';
                      PackNum                : Integer              = 0;
                      PartsTotal             : Integer              = 0)  : String; Overload;
  Function    AddPack(Peer                   : String;
                      Port                   : Word;
                      Value                  : String;
                      Compression            : Boolean              = False;
                      SendHost               : THostType            = ht_Client;
                      DataType               : TDataTypeDef         = dtString;
                      DataSize               : Integer              = -1;
                      DataTransactionType    : TDataTransactionType = dtt_Sync;
                      InitBufferID           : String               = '';
                      PackIndex              : Integer              = 0;
                      PartsTotal             : Integer              = 0)  : String; Overload;
  Function    AddPack(Peer                   : String;
                      Port,
                      LocalPort              : Word;
                      Value                  : String                  )  : String; Overload;
  Constructor Create (aSelf                  : TObject;
                      TransparentProxy       : TIdCustomTransparentProxy;
                      HostIP                 : String;
                      HostPort,
                      TimeOut,
                      RetryPacks             : Word;
                      OnError                : TOnError;
                      OnGetData              : TOnGetData;
                      OnConnected            : TOnConnected;
                      OnTimer                : TOnTimer;
                      OnPeerConnected        : TOnPeerConnected;
                      OnPeerRemoteConnect    : TOnPeerRemoteConnect;
                      OnGetLongString        : TOnGetLongString;
                      OnDataIn               : TOnDataIn;
                      OnBinaryIn             : TOnDataIn;
                      InternalTimer,
                      Connected              : PConnected;
                      BufferCapture          : PSafeString;
                      MyOnLineIP             : PMyOnLineIP;
                      MilisTimer,
                      MyPort,
                      MyOnlinePort,
                      BufferSize             : PMyPort;
                      PeersConnected         : PPeersConnected;
                      Welcome                : String;
                      Codificao              : IIdTextEncoding;
                      IPVersion              : TIdIPVersion;
                      DataPeerInfo           : TDataPeerInfo;
                      Server                 : PUDPServer;
                      RequestAlive,
                      SyncTimerInterface     : Boolean;
                      SendType               : PSendType;
                      UDPSuperClient         : TObject;
                      vPeerConnectionOK      : PConnected;
                      TCPPort                : Word;
                      OpenTrans              : PConnected;
                      {$IFDEF MSWINDOWS}
                      vPriority              : TThreadPriority = tpLowest
                      {$ENDIF});
End;

Type
 TUDPServer = Class(TThread)
 Protected
  Procedure Execute; Override;
 Private
  vKill           : Boolean;
  DataListSend    : TDataListSend;
  FTerminateEvent : TEvent;
  vServer         : PUDPServer;
  vTCPPort        : Word;
  vPeersConnected : PPeersConnected;
 Public
  Procedure   Kill;
  Procedure   AddPack(Peer                : String;
                      Port                : Word;
                      Value               : tIdBytes;
                      PackSendType        : TPackSendType = pstUDP);
  Constructor Create (aSelf               : TObject;
                      Server              : PUDPServer;
                      TCPPort             : Word;
                      PeersConnected      : PPeersConnected;
                      {$IFDEF MSWINDOWS}
                      vPriority           : TThreadPriority = tpLowest
                      {$ENDIF});
End;

Type
 TUDPSuperClient = Class(TComponent)
 Private
  vClientUDP               : TUDPClient;
  vBufferCapture, //TIdThreadSafeString;
  vWelcome,
  vMyOnLineIP,
  vHostIP,
  vLastBufferCon           : String;
  vPeerConnectionTimeOut,
  vMilisTimer,
  vBufferSize,
  vMyPort,
  vMyOnlinePort,
  vHostPort,
  vTimeOut,
  vRetryPacks              : Word;
  vOnError                 : TOnError;
  vOnGetData               : TOnGetData;
  vSendType                : TSendType;
  vOnDisconnected,
  vOnConnected             : TOnConnected;
  vOnTimer                 : TOnTimer;
  vOnGetPeerInfo           : TOnGetPeerInfo;
  vOnPeerConnected         : TOnPeerConnected;
  vOnPeerRemoteConnect     : TOnPeerRemoteConnect;
  vOnConnectionPeerTimeOut : TOnConnectionPeerTimeOut;
  vOnGetLongString         : TOnGetLongString;
  vOnBinaryIn,
  vOnDataIn                : TOnDataIn;
  vOwner                   : TComponent;
  vDataPeerInfo            : TDataPeerInfo;
  vTextEncoding            : IIdTextEncoding;
  vPeerConnectionOK,
  AbortSend,
  vInternalTimer,
  vConnected,
  vOpenTrans,
  vSyncTimerInterface      : Boolean;
  vPeersConnected          : TPeersConnected;
  vIPVersion               : TIdIPVersion;
  vIdTextEncodingType      : IdTextEncodingType;
  vTransparentProxy        : TIdCustomTransparentProxy;
  Server                   : PUDPServer;
  vRequestAlive            : Boolean;
  ConnectPeerThread        : TThreadConnection;
  vTCPPort                 : Word;
  Procedure SetConnected       (Value     : Boolean);
  Procedure DataPeerInfo       (Value     : String);
  Function  WaitConnectionEvent(BufferID  : String) : Boolean;
  Procedure WaitTerminateEvent (BufferID  : String);
  Procedure SetTextEncoding(Value : IdTextEncodingType);
  Procedure QueryFinished(Sender : TObject);
 Public
  Constructor Create           (AOwner    : TComponent); Override;
  Destructor  Destroy;   Override;
  Procedure SendRawBuffer      (Peer                : String;
                                Port                : Word;
                                Value               : tIdBytes);
  Procedure SendBuffer         (AData               : String;
                                Compression         : Boolean = False;
                                DataTransactionType : TDataTransactionType = dtt_Sync);     Overload;
  Procedure BroadcastBuffer    (AData               : String;
                                Compression         : Boolean = False);
  Procedure SendLongBuffer     (Peer                : String;
                                Port                : Word;
                                AData               : String;
                                Compression         : Boolean = False;
                                DataTransactionType : TDataTransactionType = dtt_Sync);
  Procedure SendBinary         (Peer                : String;
                                Port                : Word;
                                AData               : TIdBytes;
                                Compression         : Boolean = False;
                                DataTransactionType : TDataTransactionType = dtt_Sync);
  Procedure SendBuffer         (Peer                : String;
                                Port                : Word;
                                AData               : String;
                                Compression         : Boolean = False;
                                DataTransactionType : TDataTransactionType = dtt_Sync);     Overload;
  Procedure SendRawString      (Peer                : String;
                                Port                : Word;
                                AData               : String;
                                Compression         : Boolean = False;
                                SendPacks           : Integer = 1);
  Function  ReceiveString      (Milis     : Word = 0) : String;
  Procedure ConnectPeer        (Peer,
                                Local     : String;
                                Port,
                                LocalPort : Word);
  Procedure GetPeerInfo        (Peer      : String;
                                Port      : Word);
  Function  AddPeer            (Var AItem : TPeerConnected) : Boolean;
  Function  GetActivePeer :    TPeerConnected;
  Function  GetIpSend          (PeerConnected : TPeerConnected) : String;
  Procedure AbortSendOperation;
  Procedure SetOnGetData(Value : TOnGetData);
  Procedure SetOnGetLongString(Value : TOnGetLongString);
 Published
  Property  PeerConnectionOK        : Boolean                   Read vPeerConnectionOK;
  Property  Host                    : String                    Read vHostIP                  Write vHostIP;
  Property  Port                    : Word                      Read vHostPort                Write vHostPort;
  Property  TCPPort                 : Word                      Read vTCPPort                 Write vTCPPort;
  Property  Welcome                 : String                    Read vWelcome                 Write vWelcome;
  Property  OnLineIP                : String                    Read vMyOnLineIP;
  Property  MyPort                  : Word                      Read vMyPort;
  Property  MyOnlinePort            : Word                      Read vMyOnlinePort;
  Property  Active                  : Boolean                   Read vConnected               Write SetConnected;
  Property  TimeOutSinglePacks      : Word                      Read vTimeOut                 Write vTimeOut;
  Property  RetryPacks              : Word                      Read vRetryPacks              Write vRetryPacks;
  Property  PeersConnected          : TPeersConnected           Read vPeersConnected          Write vPeersConnected;
  Property  BufferSize              : Word                      Read vBufferSize              Write vBufferSize;
  Property  InternalTimer           : Boolean                   Read vInternalTimer           Write vInternalTimer;
  Property  Interval                : Word                      Read vMilisTimer              Write vMilisTimer;
  Property  IPVersion               : TIdIPVersion              Read vIPVersion               Write vIPVersion;
  Property  TransparentProxy        : TIdCustomTransparentProxy Read vTransparentProxy        Write vTransparentProxy;
  Property  RequestAlive            : Boolean                   Read vRequestAlive            Write vRequestAlive;
  Property  TextEncoding            : IdTextEncodingType        Read vIdTextEncodingType      Write SetTextEncoding;
  Property  SyncTimerInterface      : Boolean                   Read vSyncTimerInterface      Write vSyncTimerInterface;
  Property  SendType                : TSendType                 Read vSendType                Write vSendType;
  Property  PeerConnectionTimeOut   : Word                      Read vPeerConnectionTimeOut   Write vPeerConnectionTimeOut;
  Property  OnError                 : TOnError                  Read vOnError                 Write vOnError;
  Property  OnGetData               : TOnGetData                Read vOnGetData               Write SetOnGetData;
  Property  OnConnected             : TOnConnected              Read vOnConnected             Write vOnConnected;
  Property  OnDataIn                : TOnDataIn                 Read vOnDataIn                Write vOnDataIn;
  Property  OnBinaryIn              : TOnDataIn                 Read vOnBinaryIn              Write vOnBinaryIn;
  Property  OnDisconnected          : TOnConnected              Read vOnDisconnected          Write vOnDisconnected;
  Property  OnTimer                 : TOnTimer                  Read vOnTimer                 Write vOnTimer;
  Property  OnGetPeerInfo           : TOnGetPeerInfo            Read vOnGetPeerInfo           Write vOnGetPeerInfo;
  Property  OnGetLongString         : TOnGetLongString          Read vOnGetLongString         Write SetOnGetLongString;
  Property  OnPeerConnected         : TOnPeerConnected          Read vOnPeerConnected         Write vOnPeerConnected;
  Property  OnPeerConTimeOut        : TOnConnectionPeerTimeOut  Read vOnConnectionPeerTimeOut Write vOnConnectionPeerTimeOut;
  Property  OnPeerRemoteConnect     : TOnPeerRemoteConnect      Read vOnPeerRemoteConnect     Write vOnPeerRemoteConnect;
End;

Type
 TUDPSuperServer = Class(TComponent)
 Private
  UDPServer                       : TIdUDPServer;
  TCPServer                       : TIdTCPServer;
  vOnRead                         : TOnRead;
  vOnClientDisconnected           : TOnClientDisconnected;
  vOnClientConnected              : TOnClientConnected;
  vOwner                          : TComponent;
  vTCPPort,
  vBufferSize,
  vDefaultPort                    : Word;
  vIPVersion                      : TIdIPVersion;
  vConnectionsCount               : Integer;
  vTextEncoding                   : IIdTextEncoding;
  vIdTextEncodingType             : IdTextEncodingType;
  vPeersConnected                 : TPeersConnected;
//  UDPSendThread                   : TUDPServer;
  Function  GetActive             : Boolean;
  Procedure SetActive(Value       : Boolean);
  Function  GetBindings           : TIdSocketHandles;
  Function  GetBinding            : TIdSocketHandle;
  Procedure UDPRead(AThread       : TIdUDPListenerThread;
                    Const AData   : TIdBytes;
                    ABinding      : TIdSocketHandle);
  Procedure SetTextEncoding(Value : IdTextEncodingType);
  Procedure OnExecute          (AContext : TIdContext);
  Procedure TCPServerConnect   (AContext : TIdContext);
  Procedure TCPServerDisconnect(AContext : TIdContext); //TODO
  Procedure SendPack(Peer         : String;
                     Port         : Word;
                     Value        : tIdBytes);
 Public
  Constructor Create          (AOwner        : TComponent);Override;
  Destructor  Destroy;Override;
  Procedure   Send            (Const AHost   : String;
                               Const APort   : TIdPort;
                               Const AData   : String;
                               AByteEncoding : IIdTextEncoding = Nil;
                               SendDataPack  : Boolean = True);
  Procedure   SendBuffer      (Const AHost   : String;
                               Const APort   : TIdPort;
                               Const ABuffer : TIdBytes;
                               SendDataPack  : Boolean = True);
  Property Bindings             : TIdSocketHandles          Read GetBindings;
  Property Binding              : TIdSocketHandle           Read GetBinding;
  Property PeersConnected       : TPeersConnected           Read vPeersConnected;
 Published
  Property Active               : Boolean                   Read GetActive             Write SetActive;
  Property Port                 : Word                      Read vDefaultPort          Write vDefaultPort;
  Property TCPPort              : Word                      Read vTCPPort              Write vTCPPort;
  Property BufferSize           : Word                      Read vBufferSize           Write vBufferSize;
  Property IPVersion            : TIdIPVersion              Read vIPVersion            Write vIPVersion;
  Property ConnectionsCount     : Integer                   Read vConnectionsCount;
  Property TextEncoding         : IdTextEncodingType        Read vIdTextEncodingType   Write SetTextEncoding;
  Property OnRead               : TOnRead                   Read vOnRead               Write vOnRead;
  Property OnClientConnected    : TOnClientConnected        Read vOnClientConnected    Write vOnClientConnected;
  Property OnClientDisconnected : TOnClientDisconnected     Read vOnClientDisconnected Write vOnClientDisconnected;
End;

Function  DecompressString(Value         : String)         : String;
Function  DecompressStream(Value         : TIdBytes;
                           Var Dest      : TIdBytes) : Integer;
Function  CompressString  (Value         : String)         : String;Overload;
Function  CompressString  (Value         : String;
                           Var DataSize  : Integer)        : String;Overload;
Function  CompressStream  (Value         : TIdBytes;
                           Var Dest      : TIdBytes) : Integer;

{$IFDEF MSWINDOWS}
Function LocalIP : String;
{$ENDIF}
Function MyIpClass(MyIP : String; IPVersion : TIdIPVersion) : String;

Procedure Register;

Var
 vGeralEncode        : IIdTextEncoding;
 CompressionDecoding,
 CompressionEncoding : TEncoding;

Implementation

Procedure Register;
Begin
 RegisterComponents('UDP Super Components', [TUDPSuperServer, TUDPSuperClient,
                                             TJDRMDesktop, TJDRMDesktopView]);
End;

Function MyIpClass(MyIP : String; IPVersion : TIdIPVersion) : String;
Var
 vIpClass : String;
 I        : Integer;
Begin
 If IPVersion = Id_IPv4 Then
  Begin
   vIpClass := '';
   For I := 0 To 2 Do
    Begin
     vIpClass := vIpClass + Copy(MyIP, 1, Pos('.', MyIP));
     Delete(MyIP, 1, Pos('.', MyIP));
    End;
   Delete(vIpClass, Length(vIpClass), 1);
   Result := vIpClass;
  End
 Else
  Result := '0.0.0.0';
End;

Destructor TDataValueSend.Destroy;
Begin
 SetLength(aValue, 0);
 Inherited;
End;

Destructor TDataValueReceive.Destroy;
Begin
 SetLength(aValue, 0);
 Inherited;
End;

Destructor TDataValue.Destroy;
Begin
 SetLength(aValue, 0);
 Inherited;
End;

Function TUDPSuperClient.GetIpSend(PeerConnected : TPeerConnected) : String;
Begin
 If (PeerConnected.RemoteIP = OnLineIP)            And
    (MyIpClass(LocalIP, vIPVersion) =
     MyIpClass(PeerConnected.LocalIP, vIPVersion)) Then
  Result := PeerConnected.LocalIP
 Else
  Result := PeerConnected.RemoteIP;
End;

{$IFDEF MSWINDOWS}
Function LocalIP : String;
Type
 TaPInAddr = Array [0..10] of PInAddr;
 PaPInAddr = ^TaPInAddr;
Var
 phe       : Winsock2.PHostEnt;
 pptr      : PaPInAddr;
 Buffer    : Array [0..63] of Char;
 I         : Integer;
 GInitData : TWSADATA;
Begin
 WSAStartup($101, GInitData);
 Result := '';
 GetHostName(@Buffer, SizeOf(Buffer));
 phe    := Winsock2.GetHostByName(@Buffer);
 If phe = Nil Then
  Exit;
 pptr   := PaPInAddr(phe^.h_addr_list);
 I := 0;
 While pptr^[I] <> Nil Do
  Begin
   Result := StrPas(inet_ntoa(pptr^[I]^));
   Inc(I);
  End;
 WSACleanup;
End;

Function ParamByNameAsString(Const Params     : String;
                             Const ParamName  : String;
                             Var   Status     : Boolean;
                             Const DefValue   : String) : String;
Var
 I, J  : Integer;
 Ch    : Char;
Begin
 Status := False;
 I := 1;
 While I <= Length(Params) Do
  Begin
   J := I;
   While (I <= Length(Params)) And (Params[I] <> '=') Do
    Inc(I);
   If I > Length(Params) Then
    Begin
     Result := DefValue;
     Exit; // Not found
    End;
   If SameText(ParamName, Trim(Copy(Params, J, I - J))) Then
    Begin
     // Found parameter name, extract value
     Inc(I); // Skip '='
     If (I <= Length(Params)) And (Params[I] = '"') Then
      Begin
       // Value is between double quotes
       // Embedded double quotes and backslashes are prefixed
       // by backslash
       Status := True;
       Result := '';
       Inc(I);        // Skip starting delimiter
       While I <= Length(Params) Do
        Begin
         Ch := Params[I];
         If Ch = '\' Then
          Begin
           Inc(I);          // Skip escape character
           If I > Length(Params) Then
            Break;
           Ch := Params[I];
          End
         Else If Ch = '"' Then
          Break;
         Result := Result + Ch;
         Inc(I);
        End;
      End
     Else
      Begin
       // Value is up to semicolon or end of string
       J := I;
       While (I <= Length(Params)) And (Params[I] <> ';') Do
        Inc(I);
       Result := Copy(Params, J, I - J);
       Status := True;
      End;
     Exit;
    End;
   // Not good parameter name, skip to next
   Inc(I); // Skip '='
   If (I <= Length(Params)) And (Params[I] = '"') Then
    Begin
     Inc(I);        // Skip starting delimiter
     While I <= Length(Params) Do
      Begin
       Ch := Params[I];
       If Ch = '\' Then
        Begin
         Inc(I);          // Skip escape character
         If I > Length(Params) Then
          Break;
        End
       Else If Ch = '"' Then
        Break;
       Inc(I);
      End;
     Inc(I);        // Skip ending delimiter
    End;
   // Param ends with ';'
   While (I <= Length(Params)) And (Params[I] <> ';') Do
    Inc(I);
   Inc(I);  // Skip semicolon
  End;
 Result := DefValue;
End;

Function EscapeQuotes(Const S: String) : String;
Begin
 //Easy but not best performance
 Result := StringReplace(S, '\', TSepValueMemString, [rfReplaceAll]);
 Result := StringReplace(Result, '"', TQuotedValueMemString, [rfReplaceAll]);
End;
{$ENDIF}

procedure TDataPack.FromString(Const FromValue : String);
Var
 Status    : Boolean;
 Value     : String;
 AValue    : TValue;
 AContext  : TRttiContext;
 ARecord   : TRttiRecordType;
 AField    : TRttiField;
 AFldName  : String;
Begin
 If FromValue = '' Then
  Exit;
 // We use RTTI to iterate thru all fields of THdr and use each field name
 // to get field value from metadata string and then set value into Hdr.
 AContext := TRttiContext.Create;
 Try
  ARecord := AContext.GetType(TypeInfo(TDataPack)).AsRecord;
  For AField In ARecord.GetFields Do
   Begin
    AFldName := AField.Name;
    Value    := ParamByNameAsString(FromValue, AFldName, Status, '0');
    If Status Then
     Begin
      Try
       Case AField.FieldType.TypeKind of
        tkFloat :  // Also for TDateTime !
         Begin
          If Pos('/', Value) >= 1 Then
           AValue := StrToDateTime(Value)
          Else
           AValue := StrToFloat(Value);
          AField.SetValue(@Self, AValue);
         End;
        tkInteger :
         Begin
          AValue := StrToInt(Value);
          AField.SetValue(@Self, AValue);
         End;
        tkUString :
         Begin
          AValue := Value;
          AField.SetValue(@Self, AValue);
         End;
        tkDynArray :
         Begin
          AValue.From(ToBytes(Value));
          AField.SetValue(@Self, AValue);
         End;
        // You should add other types as well
       End;
      Except
       // Ignore any exception here. Likely to be caused by
       // invalid value format
      End;
     End
    Else
     Begin
      // Do whatever you need if the string lacks a field
      // For example clear the field, or just do nothing
     End;
   End;
 Finally
  AContext.Free;
 End;
End;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
Function TDataPack.ToString : String;
Type
 TDynamicArray = Array Of Byte;
Var
 AContext  : TRttiContext;
 AField    : TRttiField;
 ARecord   : TRttiRecordType;
 AFldName  : String;
 AValue    : TValue;
Begin
 Result := '';
 AContext := TRttiContext.Create;
 Try
  ARecord := AContext.GetType(TypeInfo(TDataPack)).AsRecord;
  For AField In ARecord.GetFields Do
   Begin
    AFldName := AField.Name;
    AValue   := AField.GetValue(@Self);
    Result := Result + AFldName + '="' + EscapeQuotes(AValue.ToString) + '";';
   End;
 Finally
  AContext.Free;
 End;
End;

Function TDataPack.GetValue : String;
Begin
 Result := CompressionDecoding.GetString(TBytes(aValue));//BytesToString(aValue, vGeralEncode);
End;

Procedure WriteRecord(Var ARecord : TDataPack; AStream: TStream);
Begin
 AStream.Position := 0;
 AStream.Write(ARecord, szMyObject);
 AStream.Write(Pointer(ARecord.GetValue)^, StrToInt(ARecord.ValueSize));
End;

Procedure ReadRecord (Var ARecord : TDataPack; AStream: TStream);
Begin
 AStream.Position := 0;
 AStream.Read (ARecord, szMyObject);
 AStream.Read (Pointer(ARecord.GetValue)^, StrToInt(ARecord.ValueSize));
End;

Function GenBufferID : String;
Var
 StartTime : Cardinal;
 Function GeraChave(Tamanho: integer): String;
 Var
  I: Integer;
  Chave: String;
 Const
  str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
 Begin
  Chave := '';
  For I := 1 To Tamanho Do
   Chave := Chave + str[random(length(str)) + 1];
  Result := Chave;
 End;
 Function MD5(Const Texto: String) : String;
 Var
  idmd5: TIdHashMessageDigest5;
 Begin
  idmd5 := TIdHashMessageDigest5.Create;
  Try
   Result := idmd5.HashStringAsHex(texto);
  Finally
   idmd5.Free;
  End;
 End;
Begin
 StartTime := TThread.GetTickCount;
 Result := MD5(GeraChave(64) + DateTimeToStr(Now) + IntToStr(StartTime));
End;

Procedure StringToValuePack(Value : String; Var DataPack : TDataPack);
Begin
// Move(Value[1], DataPack.Value[0], Length(Value) * SizeOf(Char));
End;

Procedure BuildDataPack(HostSend, HostDest  : String;
                        PortSend, PortDest  : Integer;
                        Value               : String;
                        DataType            : TDataTypeDef;
                        Var Result          : TDataPack;
                        Compression         : Boolean = False;
                        MD5                 : String  = '';
                        PackSize            : Integer = -1;
                        PackMD5             : String  = '';
                        PackIndex           : Integer = -1;
                        PartsTotal          : Integer = 1;
                        DataTransactionType : TDataTransactionType = dtt_Sync;
                        SendType            : TSendType            = stNAT);Overload;
Begin
 Result.New;
 Result.vHostSend                   := HostSend + ':' + IntToStr(PortSend);
 Result.vHostDest                   := HostDest + ':' + IntToStr(PortDest);
 Result.MD5                         := MD5;
 Result.DataType                    := Integer(DataType);
 Result.DataTransactionType         := Integer(DataTransactionType);
 Result.Compression                 := Compression;
 Result.InitBuffer                  := False;
 Result.FinalBuffer                 := False;
 Result.SendType                    := Integer(SendType);
 If Result.MD5 = '' Then
  Result.MD5   := GenBufferID;
 Result.PackMD5                     := PackMD5;
 If Result.PackMD5 = '' Then
  Result.PackMD5 := Result.MD5;
 If PackIndex = -1 Then
  Result.PackIndex := '0'
 Else
  Result.PackIndex := IntToStr(PackIndex);
 Result.PartsTotal := IntToStr(PartsTotal);
 If Length(Value) > 0 Then
  Begin
   If Compression Then
    Value           := CompressString(Value);
   If PackSize = -1 Then
    Result.PackSize := IntToStr(Length(Value)) // * szChar
   Else
    Result.PackSize := IntToStr(PackSize);
   Result.ValueSize := IntToStr(Length(Value));
   Result.aValue    := tIdBytes(CompressionDecoding.GetBytes(Value)); //ToBytes(Value, vGeralEncode);
  End;
End;

Procedure BuildDataPack(HostSend, HostDest  : String;
                        PortSend, PortDest  : Integer;
                        Value               : tIdBytes;
                        DataType            : TDataTypeDef;
                        Var Result          : TDataPack;
                        Compression         : Boolean = False;
                        MD5                 : String  = '';
                        PackSize            : Integer = -1;
                        PackIndex           : Integer = -1;
                        PackTotalSize       : Integer = -1;
                        InitBuffer          : Boolean = False;
                        FinalBuffer         : Boolean = False;
                        MasterPackID        : String  = '';
                        PartsTotal          : Integer = 1;
                        DataTransactionType : TDataTransactionType = dtt_Sync;
                        SendType            : TSendType            = stNAT);Overload;
Begin
 Result.New;
 Result.vHostSend                   := HostSend + ':' + IntToStr(PortSend);
 Result.vHostDest                   := HostDest + ':' + IntToStr(PortDest);
 Result.MD5                         := MD5;
 Result.DataType                    := Integer(DataType);
 Result.DataTransactionType         := Integer(DataTransactionType);
 Result.Compression                 := Compression;
 Result.SendType                    := Integer(SendType);
 If PackIndex    = -1 Then
  Result.PackIndex                  := '0'
 Else
  Result.PackIndex                  := IntToStr(PackIndex);
 Result.InitBuffer                  := InitBuffer;
 Result.FinalBuffer                 := FinalBuffer;
 Result.PartsTotal                  := IntToStr(PartsTotal);
 If Result.MD5   = '' Then
  Result.MD5   := GenBufferID;
 If MasterPackID = '' Then
  Result.PackMD5 := Result.MD5
 Else
  Result.PackMD5 := MasterPackID;
 If Length(Value) > 0 Then
  Begin
   Result.PackSize  := IntToStr(PackSize);
   Result.ValueSize := IntToStr(Length(Value));
   Result.aValue    := Value;
  End;
End;

Procedure StringToBytes(Value : String; Var Bytes : TIdBytes);
Begin
 Bytes := tIdBytes(CompressionDecoding.GetBytes(Value));
End;

Procedure RawBytesPack(DataPack : TDataPack; Var Result : String);
Var
 StringStream : TStringStream;
Begin
 Try
  Result := '';
  If TTransportRTTI Then
   StringStream := TStringStream.Create(DataPack.ToString, CompressionDecoding)
  Else
   Begin
    StringStream := TStringStream.Create('', CompressionDecoding);
    DataPack.SaveTo(StringStream);
   End;
  StringStream.Position := 0;
 Finally
  Result := Format(TFormatPackData, [StringStream.DataString]); //XyberX
  StringStream.Free;
 End;
End;

Function BytesDataPack(Value : String; TextEncoding : IIdTextEncoding) : TDataPack;
Var
 StringStream : TStringStream;
 vTemp        : String;
Begin
 Result.New;
 StringStream := Nil;
 Try
  vTemp := Copy(Value, Pos(TInitPack, Value) + Length(TInitPack), Pos(TFinalPack, Value) - 1);
  If vTemp <> '' Then
   Begin
    StringStream := TStringStream.Create(vTemp, CompressionDecoding); //XyberX
    If StringStream.Size > 0 Then
     Begin
      StringStream.Position := 0;
      Try
       Result.LoadFrom(StringStream);
      Except
       Result.New;
      End;
     End;
   End;
 Finally
  If StringStream <> Nil Then
   StringStream.Free;
 End;
End;

Function ReadDataString(DataPack : TDataPack) : String;
Begin
// If DataPack.PackSize > 0 Then
//  SetString(Result, PChar(@DataPack.Value[0]), DataPack.PackSize);
End;

Procedure StrToByte(Value: String; Var Dest : TIdBytes; DataType : TSendType = stNAT);
Var
 BinarySize : Integer;
// DataPack   : TDataPack;
Begin
{
 DataPack   := BytesDataPack(Value, vGeralEncode);
 BinarySize := Length(TidBytes(CompressionDecoding.GetBytes(Value)));
 DataPack.TotalSize := IntToStr(BinarySize + Length(IntToStr(BinarySize)));
 RawBytesPack(DataPack, Value);
}
 SetLength(Dest, 0);
 If (DataType = stProxy) Then
  Begin
   BinarySize := Length(TidBytes(CompressionDecoding.GetBytes(Value)));
   AppendBytes(Dest, ToBytes(BinarySize));
  End;
 AppendBytes(Dest, TidBytes(CompressionDecoding.GetBytes(Value)));
// AppendByte(Dest, BinarySize);
// Dest := TidBytes(CompressionDecoding.GetBytes(Value)); //ToBytes(Value, vGeralEncode);
// BinarySize := Length(Value) * SizeOf(Char);
// SetLength(Dest, BinarySize);
// FillChar(Dest, BinarySize, 0);
// Move(Value[1], Dest[0], BinarySize);
End;

Constructor TReceiveBuffer.Create;
Begin
 Inherited;
 vIdBuffer  := '';
 vPackNo    := 0;
 SetLength(vBuffer, 0);
 vLastCheck := Now;
End;

Constructor TPeerConnected.Create;
Begin
 Inherited;
 Connected          := False;
 TransactionOpen    := False;
 Punch              := False;
 SendPeerConnect    := False;
 OldLatency         := 0;
 RetriesTransaction := 0;
 LocalPort          := 0;
 vMaxRetriesPeerCon := MaxRetriesPeerCon;
 WelcomeMessage     := '';
 SocketHandle       := Nil;
End;

Function  TDataPack.HostSend : String;
Begin
 Result := Utf8Decode(Self.vHostSend);
 If Pos(':', Result) > 0 Then
  Result := Copy(Result, 1, Pos(':', Result) -1);
End;

Function  TDataPack.HostDest : String;
Begin
 Result := Utf8Decode(Self.vHostDest);
 If Pos(':', Result) > 0 Then
  Result := Copy(Result, 1, Pos(':', Result) -1);
End;

Function TDataPack.PortSend : Word;
Var
 vPort : String;
Begin
 Result := 0;
 vPort := Utf8Decode(Self.vHostSend);
 If Pos(':', vPort) > 0 Then
  Result := StrToInt(Copy(vPort, Pos(':', vPort) +1, Length(vPort)));
End;

Function TDataPack.PortDest : Word;
Var
 vPort : String;
Begin
 Result := 0;
 vPort := Utf8Decode(Self.vHostDest);
 If Pos(':', vPort) > 0 Then
  Result := StrToInt(Copy(vPort, Pos(':', vPort) +1, Length(vPort)));
End;

Procedure TDataPack.New;
Begin
 Self.vHostSend   := '';
 Self.vHostDest   := Self.vHostSend;
 Self.MD5         := Self.vHostDest;
 Self.Compression := False;
 Self.PackSize    := '0';
 Self.ValueSize   := '0';
 Self.SendType    := Integer(stNAT);
End;

Procedure TDataPack.SaveTo(AStream : TStream);
Begin
 TKBDynamic.WriteTo(AStream, Self, TypeInfo(TDataPack), cVersion, cDefaultOptions);
End;

Function TDataPack.LoadFrom(AStream : TStream) : Boolean;
Begin
 AStream.Position := 0;
 Result := TKBDynamic.ReadFrom(AStream, Self, TypeInfo(TDataPack), cVersion);
End;

Function  TUDPSuperServer.GetActive : Boolean;
Begin
 Result := UDPServer.Active;
End;

Procedure TUDPSuperServer.SetActive(Value : Boolean);
Begin
 UDPServer.Active         := False;
 UDPServer.DefaultPort    := vDefaultPort;
 UDPServer.BufferSize     := vBufferSize;
 UDPServer.IPVersion      := vIPVersion;
 UDPServer.OnUDPRead      := UDPRead;
 UDPServer.ReceiveTimeout := TReceiveTimeOutUDPServer;
 UDPServer.BroadcastEnabled := False;
 UDPServer.ThreadedEvent  := False;
 vConnectionsCount        := 0;
 UDPServer.Active         := Value;
 If vTCPPort > 0 Then
  Begin
   If Not TCPServer.Active Then
    TCPServer.DefaultPort := vTCPPort;
   Try
    If TCPServer.Active Then
     TCPServer.StopListening;
//    TCPServer.UseNagle    := True;
    TCPServer.Active      := Value;
   Except
   End;
  End;
{
 If (UDPSendThread <> Nil) Then
  Begin
   Try
    UDPSendThread.Kill;
   Except
   End;
   WaitForSingleObject(UDPSendThread.Handle, TThreadWaitDead);
   UDPSendThread := Nil;
   FreeAndNil(UDPSendThread);
  End;
}
 If Not UDPServer.Active Then
  vPeersConnected.ClearList;
{
 Else
  Begin
   UDPSendThread := TUDPServer.Create(Self, @UDPServer, vTCPPort, @vPeersConnected);
   UDPSendThread.Resume;
  End;
}
End;

Function  TUDPSuperServer.GetBinding  : TIdSocketHandle;
Begin
 Result := UDPServer.Binding;
End;

Function  TUDPSuperServer.GetBindings : TIdSocketHandles;
Begin
 Result := UDPServer.Bindings;
End;

Procedure   TUDPSuperServer.SendBuffer(Const AHost   : String;
                                       Const APort   : TIdPort;
                                       Const ABuffer : TIdBytes;
                                       SendDataPack  : Boolean = True);
Var
 vTempBuffer  : TIdBytes;
 DataPackTemp : TDataPack;
 vDados       : String;
Begin
 vTempBuffer := ABuffer;
 If SendDataPack Then
  Begin
   BuildDataPack(AHost, Self.Binding.IP, APort, Self.Binding.Port, BytesToString(ABuffer, vTextEncoding), dtString, DataPackTemp);
   RawBytesPack(DataPackTemp, vDados);
   StrToByte(vDados, vTempBuffer);
  End
 Else
  vTempBuffer := ABuffer;
 If UDPServer.Active Then
   UDPServer.SendBuffer(AHost, APort, vIPVersion, vTempBuffer);
 {$IFDEF MSWINDOWS}
 {$IFNDEF FMX}Application.Processmessages;
       {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
 {$ENDIF}
End;

Procedure   TUDPSuperServer.Send(Const AHost   : String;
                                 Const APort   : TIdPort;
                                 Const AData   : String;
                                 AByteEncoding : IIdTextEncoding = Nil;
                                 SendDataPack  : Boolean = True);
Var
 DataPackTemp : TDataPack;
 vDados       : String;
Begin
 If UDPServer.Active Then
  Begin
   If SendDataPack Then
    Begin
     BuildDataPack(AHost, Self.Binding.IP, APort, Self.Binding.Port, AData, dtString, DataPackTemp);
     RawBytesPack(DataPackTemp, vDados);
    End
   Else
    vDados       := AData;
   If AByteEncoding = Nil Then
    UDPServer.SendBuffer(AHost, APort, ToBytes(vDados, vTextEncoding))
//    UDPServer.Send(AHost, APort, vDados, vTextEncoding)
   Else
    UDPServer.SendBuffer(AHost, APort, ToBytes(vDados, AByteEncoding));
//    UDPServer.Send(AHost, APort, vDados, AByteEncoding);
   {$IFDEF MSWINDOWS}
   {$IFNDEF FMX}Application.Processmessages;
         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
   {$ENDIF}
  End;
End;

Constructor TUDPSuperServer.Create(AOwner : TComponent);
Begin
 Inherited;
 vOwner                     := AOwner;
 vPeersConnected            := TPeersConnected.Create;
 vBufferSize                := BUFFER_SIZE;
 vIPVersion                 := id_IPv4;
 vConnectionsCount          := 0;
 vIdTextEncodingType        := encASCII;
 vTextEncoding              := IndyTextEncoding_ASCII;
// CompressionEncoding        := TEncoding.UTF8;
 vGeralEncode               := vTextEncoding;
 UDPServer                  := TIdUDPServer.Create(Nil);
 UDPServer.IPVersion        := vIPVersion;
 UDPServer.OnUDPRead        := UDPRead;
 UDPServer.BufferSize       := vBufferSize;
 UDPServer.BroadcastEnabled := False;
 UDPServer.ThreadedEvent    := False;
 TCPServer                  := TIdTCPServer.Create(Nil);
 TCPServer.Contexts.OwnsObjects := True;
 TCPServer.OnExecute        := OnExecute;
 TCPServer.OnConnect        := TCPServerConnect;
 TCPServer.OnDisconnect     := TCPServerDisconnect;
End;

procedure TUDPSuperServer.TCPServerConnect(AContext: TIdContext);
Var
 aClient : TPeerConnected;
Begin
 aClient            := TPeerConnected.Create;
 aClient.RemoteIP   := AContext.Binding.PeerIP;
 aClient.TCPPort    := AContext.Binding.PeerPort;
 aClient.AContext   := AContext;
 AContext.Data      := aClient;
 vPeersConnected.AddPeer(aClient);
End;

Procedure TUDPSuperServer.TCPServerDisconnect(AContext: TIdContext);
Var
 RemoteIP : String;
 TCPPort  : Integer;
 aData    : TPeerConnected;
Begin
 aData    := TPeerConnected(AContext.Data);
 RemoteIP := aData.RemoteIP;
 TCPPort  := aData.TCPPort;
 Try
  vPeersConnected.DeleteItem(RemoteIP, TCPPort);
//  TPeerConnected(AContext.Data).AContext := Nil;
  vConnectionsCount := vPeersConnected.Count;
  If Assigned(vOnClientDisconnected) Then
   vOnClientDisconnected(AContext.Binding);
  AContext.Data := Nil;
 Except
 End;
End;

Procedure TUDPSuperServer.OnExecute(AContext : TIdContext);
Var
 aBuf : TIdBytes;
 vTransactionData,
 vHolePunch,
 vWelcomeTemp,
 StrTemp,
 vReplyLine,
 vReply,
 vHost,
 StrMD5           : String;
 vPort            : Word;
 vGetAtualTick    : Integer;
 vTempBuffer      : tidBytes;
 AItem            : TPeerConnected;
 DataPackTemp,
 DataPack         : TDataPack;
 Procedure SendConnect(Value : String);
 Var
  vTransactionData,
  Error,
  vHost1,
  vLocalHost1,
  HostString1,
  vHost2,
  vLocalHost2,
  HostString2  : String;
  Port1,
  PortLocal1,
  Port2,
  PortLocal2   : Integer;
  AItem1,
  AItem2       : TPeerConnected;
 Begin
  Value        := StringReplace(Value, TConnectPeer, '', [rfReplaceAll]);
  vHost1       := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  vLocalHost1  := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port1        := StrToInt(Copy(Value, 1, Pos('!', Value) -1));
  Delete(Value, 1, Pos('!', Value));
  PortLocal1   := StrToInt(Copy(Value, 1, Pos(TDelimiter, Value) -1));
  Delete(Value, 1, Pos(TDelimiter, Value) + Length(TDelimiter) -1);
  vHost2       := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  vLocalHost2  := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port2        := StrToInt(Copy(Value, 1, Pos('!', Value) -1));
  Delete(Value, 1, Pos('!', Value));
  PortLocal2   := StrToInt(Copy(Value, 1, Length(Value)));
  HostString1  := Format('%s|%s:%d!%d', [vHost2, vLocalHost2, Port2, PortLocal2]);
  HostString2  := Format('%s|%s:%d!%d', [vHost1, vLocalHost1, Port1, PortLocal1]);
  vPeersConnected.GetPeerInfo(vHost1, Port1, AItem1);
  vPeersConnected.GetPeerInfo(vHost2, Port2, AItem2);
  Try
   vTransactionData := Format(TOpenTransactionInfo, [HostString1]);
   BuildDataPack(Self.Binding.IP,
                 vHost1,
                 TCPServer.DefaultPort,
                 Port1,
                 vTransactionData, dtString, DataPack);
   RawBytesPack(DataPack, vTransactionData);
   StrToByte(vTransactionData, vTempBuffer, stProxy);
//   TCPServer.IOHandler. Write(vTempBuffer);
   Try
    AItem1.AContext.Connection.IOHandler.Write(vTempBuffer);
   Except
   End;
   If UDPServer.Active Then
//    If UDPSendThread <> Nil Then
     UDPServer.SendBuffer(vHost1, Port1, vTempBuffer);
   {$IFDEF MSWINDOWS}
   {$IFNDEF FMX}Application.Processmessages;
         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
   {$ENDIF}
   vTransactionData := Format(TOpenTransactionInfo, [HostString2]);
   BuildDataPack(Self.Binding.IP,
                 vHost2,
                 TCPServer.DefaultPort,
                 Port2,
                 vTransactionData, dtString, DataPack);
   RawBytesPack(DataPack, vTransactionData);
   StrToByte(vTransactionData, vTempBuffer, stProxy);
   Try
    AItem2.AContext.Connection.IOHandler.Write(vTempBuffer);
   Except
   End;
   If UDPServer.Active Then
//    If UDPSendThread <> Nil Then
    UDPServer.SendBuffer(vHost2, Port2, vTempBuffer);
   {$IFDEF MSWINDOWS}
   {$IFNDEF FMX}Application.Processmessages;
         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
   {$ENDIF}
  Except
   On E : Exception Do
    Begin
     Error := E.Message;
    End;
  End;
 End;
Begin
 Try
  AContext.Connection.IOHandler.CheckForDisconnect;
  If AContext.Connection.IOHandler.InputBuffer.Size > 0 Then
   Begin
    AContext.Connection.IOHandler.InputBuffer.ExtractToBytes(aBuf);
//    AContext.Connection.IOHandler.ReadBytes(aBuf, -1);
    If (Length(aBuf) = 0) Then //IOHandler.CheckForDataOnSource(TReceiveTime)) Then
     Begin
//      {$IFDEF MSWINDOWS}
//      {$IFNDEF FMX}Application.Processmessages;
//            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
//      {$ENDIF}
      Sleep(1);
      Exit;
     End;
   End
  Else
   Begin
    Sleep(1);
    Exit;
   End;
 Except
//  {$IFDEF MSWINDOWS}
//  {$IFNDEF FMX}Application.Processmessages;
//        {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
//  {$ENDIF}
//  Sleep(1);
  Abort;
 End;
//  If AContext.Connection.IOHandler.InputBuffer.Size > 0 Then
//   AContext.Connection.IOHandler.InputBuffer.ExtractToBytes(aBuf)
 Try
  vHolePunch   := CompressionDecoding.GetString(TBytes(aBuf));
  DataPack     := BytesDataPack(vHolePunch, vTextEncoding);
 Except
  vHolePunch   := CompressionDecoding.GetString(TBytes(aBuf));
  DataPack     := BytesDataPack(vHolePunch, vTextEncoding);
 End;
 StrTemp  := DataPack.GetValue;//BytesToString(AData,   vTextEncoding);
 If Pos(TInitPack, vHolePunch) = 0 Then
  Begin
   If Assigned(vOnRead) Then
    Begin
     If vHolePunch <> '' Then
      vOnRead(Nil, vHolePunch, AContext.Binding);
    End;
  End
 Else
  Begin
   StrMD5   := DataPack.MD5;
   If Length(StrTemp) = 0 Then
    Exit;
//   StrTemp  := DataPack.GetValue;
   Try
    If DataPack.Compression Then
     StrTemp  := DecompressString(StrTemp);
    If Pos(TConnecClient, StrTemp) > 0 Then
     Begin
      StrTemp            := Copy(StrTemp, Pos(TConnecClient, StrTemp) + Length(TConnecClient), Length(StrTemp));
      AItem              := TPeerConnected(AContext.Data);
      TPeerConnected(AContext.Data).LastCheck := Now;
      If Pos(TMyLocalIPInit, StrTemp) > 0 Then
       Begin
        AItem.LocalIP   := Copy(StrTemp, Pos(TMyLocalIPInit, StrTemp)  + Length(TMyLocalIPInit),  Pos(':', StrTemp) - 1 - Length(TMyLocalIPInit));
        Delete(StrTemp, 1,  Pos(':', StrTemp));
        TPeerConnected(AContext.Data).LocalPort := StrToInt(Copy(StrTemp, 1,  Pos(TMyLocalIPFinal, StrTemp) - 1));
        Delete(StrTemp, 1,  Pos(TMyLocalIPFinal, StrTemp) -1);
       End;
      vWelcomeTemp       := Copy(StrTemp, Pos(TMyLocalIPFinal, StrTemp) + Length(TMyLocalIPFinal), Length(StrTemp));
      vReplyLine         := AContext.Binding.PeerIP + TGetIp + IntToStr(AContext.Binding.PeerPort) + TGetPort;
//      DataPack.aValue    := tIdBytes(CompressionDecoding.GetBytes(vReplyLine));
      BuildDataPack(Self.Binding.IP,
                    AContext.Binding.PeerIP,
                    TCPServer.DefaultPort,
                    AContext.Binding.PeerPort,
                    vReplyLine, dtString, DataPack);
      RawBytesPack(DataPack, vTransactionData);
      StrToByte(vTransactionData, vTempBuffer, stProxy);
      AContext.Connection.IOHandler.Write(vTempBuffer);
      If UDPServer.Active Then
       UDPServer.SendBuffer(AContext.Binding.PeerIP, AContext.Binding.PeerPort, vTempBuffer);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
      TPeerConnected(AContext.Data).WelcomeMessage := vWelcomeTemp;
      If vPeersConnected.AddPeer(AItem) Then
       Begin
        vConnectionsCount := vPeersConnected.Count;
        If Assigned(vOnClientConnected) Then
         vOnClientConnected(AContext.Binding);
       End;
      vConnectionsCount := vPeersConnected.Count;
     End
    Else If Pos(TDisconnecClient, StrTemp) > 0 Then
     Begin
      vPeersConnected.DeleteItem(DataPack.HostSend, DataPack.PortSend);
      vConnectionsCount := vPeersConnected.Count;
      If Assigned(vOnClientDisconnected) Then
       vOnClientDisconnected(AContext.Binding);
     End
    Else If Pos(TGetPeerInfo, StrTemp)     > 0 Then
     Begin                             //XyberX
      StrTemp := Copy(StrTemp, Pos(TGetPeerInfo, StrTemp)      + Length(TGetPeerInfo), Length(StrTemp));
      vHost   := Copy(StrTemp, Pos(TGetIp, StrTemp)            + Length(TGetIp),       Pos(TDelimiter, StrTemp) - Length(TGetIp)   - 1);
      StrTemp := Copy(StrTemp, Pos(TDelimiter, StrTemp)        + Length(TDelimiter),   Length(StrTemp));
      vPort   := StrToInt(Copy(StrTemp, Pos(TGetPort, StrTemp) + Length(TGetPort),     Pos(TDelimiter, StrTemp) - Length(TGetPort) - 1));
      vPeersConnected.GetPeerInfo(vHost, vPort, AItem);
      If AItem = Nil Then
       vReply := Format(TPeerNoDataPackData, [vHost, IntToStr(vPort)])
      Else
       vReply := Format(TPeerInfoPackData,   [vHost, IntToStr(vPort), AItem.LocalIP]);
      BuildDataPack(DataPack.HostSend, Self.Binding.IP, DataPack.PortSend, TCPServer.DefaultPort, vReply, dtString, DataPackTemp);
      RawBytesPack(DataPackTemp, vTransactionData);
      StrToByte(vTransactionData, vTempBuffer, stProxy);
      If UDPServer.Active Then
//       If UDPSendThread <> Nil Then
        UDPServer.SendBuffer(DataPack.HostSend, DataPack.PortSend, vTempBuffer);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
     End
    Else If Pos(TSendPing, StrTemp)     > 0 Then
     Begin
      vPeersConnected.GetPeerInfo(DataPack.HostSend, DataPack.PortSend, AItem);
      If AItem <> Nil Then
       Begin
        vGetAtualTick    := GetTickCount;
        AItem.Latency    := vGetAtualTick - AItem.OldLatency;
        AItem.OldLatency := vGetAtualTick;
        AItem.LastCheck  := Now;
       End;
     End
    Else If Pos(TConnectPeer, StrTemp)  > 0 Then
     SendConnect(StrTemp)
    Else If TSendType(DataPack.SendType) = stProxy Then
     Begin
      If UDPServer.Active Then
       UDPServer.SendBuffer(DataPack.HostSend, DataPack.PortSend, aBuf);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
     End
    Else If Assigned(vOnRead) Then
     Begin
      If StrTemp <> '' Then
       vOnRead(Nil, StrTemp, AContext.Binding);
     End;
   Except
   End;
  End;
 {$IFDEF MSWINDOWS}
 {$IFNDEF FMX}Application.Processmessages;
       {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
 {$ENDIF}
 Sleep(1);
End;

Destructor  TUDPSuperServer.Destroy;
Begin
 UDPServer.Active := False;
 FreeAndNil(UDPServer);
 vPeersConnected.ClearList;
 vPeersConnected.Free;
 Inherited;
End;

Procedure TUDPSuperServer.SetTextEncoding(Value : IdTextEncodingType);
Begin
 vIdTextEncodingType := Value;
 Case Value Of
  encIndyDefault,
  encOSDefault,
  encUTF16BE,
  encUTF16LE,
  encUTF7, encUTF8  :
   Begin
    vTextEncoding       := IndyTextEncoding_UTF8;
    CompressionEncoding := TEncoding.UTF8;
   End;
  enc8Bit, encASCII :
   Begin
    vTextEncoding       := IndyTextEncoding_ASCII;
    CompressionEncoding := TEncoding.ANSI;
   End;
 End;
 vGeralEncode := vTextEncoding;
End;

Procedure TUDPSuperServer.SendPack(Peer         : String;
                                   Port         : Word;
                                   Value        : tIdBytes);
Var
 PeerConnect : TPeerConnected;
Begin
 vPeersConnected.GetPeerInfo(Peer,
                             Port,
                             PeerConnect);
 If PeerConnect <> Nil Then
  Begin
   If PeerConnect.AContext <> Nil Then
    Begin
//     PeerConnect.AContext.Connection.IOHandler.Write(Value, Length(Value));
     PeerConnect.AContext.Connection.Socket.WriteDirect(Value, Length(Value));
     PeerConnect.AContext.Connection.Socket.WriteBufferFlush;
    End;
  End;
End;

Procedure TUDPSuperServer.UDPRead(AThread     : TIdUDPListenerThread;
                                  Const AData : TIdBytes;
                                  ABinding    : TIdSocketHandle);
Var
 vTransactionData,
 vHolePunch,
 vWelcomeTemp,
 StrTemp,
 vReplyLine,
 vReply,
 vHost,
 StrMD5           : String;
 vPort            : Word;
 vGetAtualTick    : Integer;
 vTempBuffer      : tidBytes;
 AItem            : TPeerConnected;
 DataPackTemp,
 DataPack         : TDataPack;
 Procedure SendConnect(Value : String);
 Var
  vTransactionData,
  Error,
  vHost1,
  vLocalHost1,
  HostString1,
  vHost2,
  vLocalHost2,
  HostString2  : String;
  Port1,
  PortLocal1,
  Port2,
  PortLocal2   : Integer;
  AItem1,
  AItem2       : TPeerConnected;
 Begin
  Value        := StringReplace(Value, TConnectPeer, '', [rfReplaceAll]);
  vHost1       := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  vLocalHost1  := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port1        := StrToInt(Copy(Value, 1, Pos('!', Value) -1));
  Delete(Value, 1, Pos('!', Value));
  PortLocal1   := StrToInt(Copy(Value, 1, Pos(TDelimiter, Value) -1));
  Delete(Value, 1, Pos(TDelimiter, Value) + Length(TDelimiter) -1);
  vHost2       := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  vLocalHost2  := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port2        := StrToInt(Copy(Value, 1, Pos('!', Value) -1));
  Delete(Value, 1, Pos('!', Value));
  PortLocal2   := StrToInt(Copy(Value, 1, Length(Value)));
  HostString1  := Format('%s|%s:%d!%d', [vHost2, vLocalHost2, Port2, PortLocal2]);
  HostString2  := Format('%s|%s:%d!%d', [vHost1, vLocalHost1, Port1, PortLocal1]);
  vPeersConnected.GetPeerInfo(vHost1, Port1, AItem1);
  vPeersConnected.GetPeerInfo(vHost2, Port2, AItem2);
  Try
   vTransactionData := Format(TOpenTransactionInfo, [HostString1]);
   BuildDataPack(Self.Binding.IP,
                 vHost1,
                 Self.Binding.Port,
                 Port1,
                 vTransactionData, dtString, DataPack);
   RawBytesPack(DataPack, vTransactionData);
   StrToByte(vTransactionData, vTempBuffer);
   Try
    AItem1.AContext.Connection.IOHandler.Write(vTempBuffer);
   Except
   End;
   If UDPServer.Active Then
    UDPServer.SendBuffer(vHost1, Port1, vTempBuffer);
   {$IFDEF MSWINDOWS}
   {$IFNDEF FMX}Application.Processmessages;
         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
   {$ENDIF}
   vTransactionData := Format(TOpenTransactionInfo, [HostString2]);
   BuildDataPack(Self.Binding.IP,
                 vHost2,
                 Self.Binding.Port,
                 Port2,
                 vTransactionData, dtString, DataPack);
   RawBytesPack(DataPack, vTransactionData);
   StrToByte(vTransactionData, vTempBuffer);
   Try
    AItem2.AContext.Connection.IOHandler.Write(vTempBuffer);
   Except
   End;
   If UDPServer.Active Then
    UDPServer.SendBuffer(vHost2, Port2, vTempBuffer);
   {$IFDEF MSWINDOWS}
   {$IFNDEF FMX}Application.Processmessages;
         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
   {$ENDIF}
  Except
   On E : Exception Do
    Begin
     Error := E.Message;
    End;
  End;
 End;
Begin
 Try
  vHolePunch   := CompressionDecoding.GetString(TBytes(AData));
  DataPack     := BytesDataPack(vHolePunch, vTextEncoding);
 Except
  vHolePunch   := CompressionDecoding.GetString(TBytes(AData));
  DataPack     := BytesDataPack(vHolePunch, vTextEncoding);
 End;
 StrTemp  := DataPack.GetValue;//BytesToString(AData,   vTextEncoding);
 If Pos(TInitPack, vHolePunch) = 0 Then
  Begin
   If Assigned(vOnRead) Then
    Begin
     If vHolePunch <> '' Then
      vOnRead(AThread, vHolePunch, ABinding);
    End;
  End
 Else
  Begin
   StrMD5   := DataPack.MD5;
   StrTemp  := DataPack.GetValue;
   Try
    If DataPack.Compression Then
     StrTemp  := DecompressString(StrTemp);
    If Pos(TConnecClient, StrTemp) > 0 Then
     Begin
      StrTemp            := Copy(StrTemp, Pos(TConnecClient, StrTemp) + Length(TConnecClient), Length(StrTemp));
      AItem              := TPeerConnected.Create;
      AItem.RemoteIP     := ABinding.PeerIP;
      AItem.Port         := ABinding.PeerPort;
      AItem.LastCheck    := Now;
      AItem.SocketHandle := @ABinding;
      If Pos(TMyLocalIPInit, StrTemp) > 0 Then
       Begin
        AItem.LocalIP   := Copy(StrTemp, Pos(TMyLocalIPInit, StrTemp)  + Length(TMyLocalIPInit),  Pos(':', StrTemp) - 1 - Length(TMyLocalIPInit));
        Delete(StrTemp, 1,  Pos(':', StrTemp));
        AItem.LocalPort := StrToInt(Copy(StrTemp, 1,  Pos(TMyLocalIPFinal, StrTemp) - 1));
        Delete(StrTemp, 1,  Pos(TMyLocalIPFinal, StrTemp) -1);
       End;
      vWelcomeTemp       := Copy(StrTemp, Pos(TMyLocalIPFinal, StrTemp) + Length(TMyLocalIPFinal), Length(StrTemp));
      vReplyLine         := ABinding.PeerIP + TGetIp + IntToStr(ABinding.PeerPort) + TGetPort;
//      DataPack.aValue    := tIdBytes(CompressionDecoding.GetBytes(vReplyLine));
      BuildDataPack(Self.Binding.IP,
                    ABinding.PeerIP,
                    Self.Binding.Port,
                    ABinding.PeerPort,
                    vReplyLine, dtString, DataPack);
      RawBytesPack(DataPack, vTransactionData);
      StrToByte(vTransactionData, vTempBuffer);
      If UDPServer.Active Then
       UDPServer.SendBuffer(ABinding.PeerIP, ABinding.PeerPort, vTempBuffer);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
      AItem.WelcomeMessage := vWelcomeTemp;
      If vPeersConnected.AddPeer(AItem) Then
       Begin
        vConnectionsCount := vPeersConnected.Count;
        If Assigned(vOnClientConnected) Then
         vOnClientConnected(ABinding);
       End;
      vConnectionsCount := vPeersConnected.Count;
     End
    Else If Pos(TDisconnecClient, StrTemp) > 0 Then
     Begin
      vPeersConnected.DeleteItem(DataPack.HostSend, DataPack.PortSend);
      vConnectionsCount := vPeersConnected.Count;
      If Assigned(vOnClientDisconnected) Then
       vOnClientDisconnected(ABinding);
     End
    Else If Pos(TGetPeerInfo, StrTemp)     > 0 Then
     Begin                             //XyberX
      StrTemp := Copy(StrTemp, Pos(TGetPeerInfo, StrTemp)      + Length(TGetPeerInfo), Length(StrTemp));
      vHost   := Copy(StrTemp, Pos(TGetIp, StrTemp)            + Length(TGetIp),       Pos(TDelimiter, StrTemp) - Length(TGetIp)   - 1);
      StrTemp := Copy(StrTemp, Pos(TDelimiter, StrTemp)        + Length(TDelimiter),   Length(StrTemp));
      vPort   := StrToInt(Copy(StrTemp, Pos(TGetPort, StrTemp) + Length(TGetPort),     Pos(TDelimiter, StrTemp) - Length(TGetPort) - 1));
      vPeersConnected.GetPeerInfo(vHost, vPort, AItem);
      If AItem = Nil Then
       vReply := Format(TPeerNoDataPackData, [vHost, IntToStr(vPort)])
      Else
       vReply := Format(TPeerInfoPackData,   [vHost, IntToStr(vPort), AItem.LocalIP]);
      BuildDataPack(DataPack.HostSend, Self.Binding.IP, DataPack.PortSend, Self.Binding.Port, vReply, dtString, DataPackTemp);
      RawBytesPack(DataPackTemp, vTransactionData);
      StrToByte(vTransactionData, vTempBuffer);
      If UDPServer.Active Then
       UDPServer.SendBuffer(DataPack.HostSend, DataPack.PortSend, vTempBuffer);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
     End
    Else If Pos(TSendPing, StrTemp)     > 0 Then
     Begin
      vPeersConnected.GetPeerInfo(DataPack.HostSend, DataPack.PortSend, AItem);
      If AItem <> Nil Then
       Begin
        vGetAtualTick    := GetTickCount;
        AItem.Latency    := vGetAtualTick - AItem.OldLatency;
        AItem.OldLatency := vGetAtualTick;
        AItem.LastCheck  := Now;
       End;
     End
    Else If Pos(TConnectPeer, StrTemp)  > 0 Then
     SendConnect(StrTemp)
    Else If TSendType(DataPack.SendType) = stProxy Then
     Begin
      If UDPServer.Active Then
       UDPServer.SendBuffer(DataPack.HostSend, DataPack.PortSend, AData); //, pstTCP);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
     End
    Else If Assigned(vOnRead) Then
     Begin
      If StrTemp <> '' Then
       vOnRead(AThread, StrTemp, ABinding);
     End;
   Except
   End;
  End;
End;

Function TReceiveBuffers.GetValue(PackID : String) : String;
Var
 StringStream : TStringData;
 vTempBuffer  : String;
 vBufferSizeTemp,
 vPosition,
 vPackSize,
 vPackSizeIn,
 vPartsTotal,
 I, vParts     : Integer;
 ReceiveBuffer : TReceiveBuffer;
 vLogStream    : TStringStream;
 Function ArrayToString(Const A : TStringData) : String;
 Var
  I : Integer;
 Begin
  Result := '';
  For I := 0 To Length(A) -1 do
   Result := Result + A[I];
 End;
 Procedure CopyData(Const Source : TReceiveBuffer; Var Dest : TReceiveBuffer);
 Begin
  Dest.LastCheck    := Source.LastCheck;
  Dest.PackNo       := Source.PackNo;
  Dest.PartsTotal   := Source.PartsTotal;
  Dest.IdBuffer     := Source.IdBuffer;
  Dest.Buffer       := Source.Buffer;
  Dest.BufferSize   := Source.BufferSize;
 End;
Begin
 SetLength(Result, 0);
 Try
  vParts      := 0;
  vPackSize   := 0;
  vPackSizeIn := 0;
  vPartsTotal := 0;
  If Self.Count > 0 Then
   Begin
    Try
     If Self <> Nil Then
      Begin
       System.TMonitor.Enter(Self);
       vBufferSizeTemp := vBufferSize;
       ReceiveBuffer := TReceiveBuffer.Create;
       Try
        For I := Count -1 Downto 0 Do
         Begin
          CopyData(TReceiveBuffer(Self[I]), ReceiveBuffer);
          If ReceiveBuffer.vIdBuffer = PackID Then
           Begin
            vPackSize := ReceiveBuffer.BufferSize;
            If Length(StringStream) = 0 Then
             Begin
              If vPosition > ReceiveBuffer.PartsTotal Then
               vPartsTotal := vPosition
              Else
               vPartsTotal := ReceiveBuffer.PartsTotal;
              SetLength(StringStream, vPartsTotal);
             End;
            vPosition   := ReceiveBuffer.PackNo;
            vTempBuffer := ReceiveBuffer.Buffer;
            StringStream[vPosition] := vTempBuffer;
            vPackSizeIn := vPackSizeIn + Length(vTempBuffer);
            Inc(vParts);
           End;
         End;
       Finally
        ReceiveBuffer.Free;
       End;
      End;
    Finally
     If (vPackSizeIn = vPackSize) And
        (vPackSize > 0) Then
      Result := ArrayToString(StringStream);
     SetLength(StringStream, 0);
     If Self <> Nil Then
      Begin
       System.TMonitor.PulseAll(Self);
       System.TMonitor.Exit(Self);
      End;
    End;
   End;
 Except

 End;
End;

Function TPeersConnected.GetValue(Index  : Integer) : TPeerConnected;
Begin
 Result := Nil;
 If Self.Count > 0 Then
  Result := TPeerConnected(Self[Index]);
End;

Function TDataListSend.GetValue(Index  : Integer) : TDataValueSend;
Begin
 Result := Nil;
 If Self.Count > 0 Then
  Result := TDataValueSend(Self[Index]);
End;

Function TDataListReceive.GetValue(Index  : Integer) : TDataValueReceive;
Begin
 Result := Nil;
 If Self.Count > 0 Then
  Result := TDataValueReceive(Self[Index]);
End;

Function TDataList.GetValue(Index  : Integer) : TDataValue;
Begin
 Result := Nil;
 If Self.Count > 0 Then
  Result := TDataValue(Self[Index]);
End;

Procedure TPeersConnected.AddBind(Ip : String; Port : Integer; Server : TIdUDPServer);
Var
 I            : Integer;
 vFounded     : Boolean;
 SocketHandle : TIdSocketHandle;
Begin
 vFounded := False;
 For I := 0 To Server.Bindings.Count -1 Do
  Begin
   vFounded := (Server.Bindings[I].IP   = ip) And
               (Server.Bindings[I].Port = Port);
   If vFounded Then
    Break;
  End;
 If Not vFounded Then
  Begin
   SocketHandle      := Server.Bindings.Add;
   SocketHandle.IP   := IP;
   SocketHandle.Port := Port;
  End;
End;

Function TReceiveBuffers.AddItem (Var AItem   : TReceiveBuffer) : Boolean;
Begin
 Result := False;
 Try
  System.TMonitor.Enter(Self);
  Self.Add(AItem);
  Result := True;
 Finally
  System.TMonitor.PulseAll(Self);
  System.TMonitor.Exit(Self);
 End;
End;

Function TPeersConnected.AddPeer(Var AItem : TPeerConnected) : Boolean;
Var
 I, A  : Integer;
 vFind : Boolean;
Begin
 Result := False;
 A      := -1;
 If Self.Count > 0 Then
  Begin
   vFind := False;
   For I := Self.Count -1 DownTo 0 Do
    Begin
     vFind := (TPeerConnected(Self[I]).RemoteIP = AItem.RemoteIP) And
              (((TPeerConnected(Self[I]).Port > 0) And
                (TPeerConnected(Self[I]).Port    = AItem.Port)) Or
               ((TPeerConnected(Self[I]).TCPPort > 0) And
                (TPeerConnected(Self[I]).TCPPort = AItem.TCPPort)));
     If vFind Then
      Begin
//       FreeAndNil(AItem);
       A := I;
       Break;
      End;
    End;
   If Not vFind Then
    Begin
     AItem.OldLatency := GetTickCount;
     AItem.Latency    := 0;
     Result           := True;
     Try
      System.TMonitor.Enter(Self);
      Self.Add(AItem);
     Finally
      System.TMonitor.PulseAll(Self);
      System.TMonitor.Exit(Self);
     End;
    End
   Else
    Begin
     If A > -1 Then
      Begin
       TPeerConnected(Self[A]).TransactionOpen    := AItem.TransactionOpen;
       TPeerConnected(Self[A]).vMaxRetriesPeerCon := AItem.vMaxRetriesPeerCon;
       TPeerConnected(Self[A]).OldLatency         := AItem.OldLatency;
       TPeerConnected(Self[A]).RetriesTransaction := AItem.RetriesTransaction;
       TPeerConnected(Self[A]).LastNegociateCheck := AItem.LastNegociateCheck;
       TPeerConnected(Self[A]).RemoteIP           := AItem.RemoteIP;
       TPeerConnected(Self[A]).LocalIP            := AItem.LocalIP;
       TPeerConnected(Self[A]).LocalPort          := AItem.LocalPort;
       TPeerConnected(Self[A]).SendMessage        := AItem.SendMessage;
       TPeerConnected(Self[A]).WelcomeMessage     := AItem.WelcomeMessage;
       Result           := True;
      End;
    End;
  End
 Else
  Begin
   AItem.OldLatency := GetTickCount;
   AItem.Latency := 0;
   Result        := True;
   Try
    System.TMonitor.Enter(Self);
    Self.Add(AItem);
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TDataListReceive.AddValue(aValue : TidBytes);
Var
 AItem : TDataValueReceive;
Begin
 AItem := TDataValueReceive.Create;
 SetLength(AItem.aValue, Length(aValue));
 System.Move(aValue[0], AItem.aValue[0], Length(aValue));
 AddItem(AItem);
End;

Procedure TDataListSend.AddValue(Host         : String;
                                 Port         : Integer;
                                 aValue       : TidBytes;
                                 PackSendType : TPackSendType = pstUDP);
Var
 AItem : TDataValueSend;
Begin
 AItem              := TDataValueSend.Create;
 AItem.Host         := Host;
 AItem.Port         := Port;
 AItem.PackSendType := PackSendType;
 SetLength(AItem.aValue, Length(aValue));
 System.Move(aValue[0], AItem.aValue[0], Length(aValue));
 AddItem(AItem);
End;

Procedure TDataListReceive.AddItem(Const AItem : TDataValueReceive);
Begin
 Try
  System.TMonitor.Enter(Self);
  Self.Add(AItem);
 Finally
  System.TMonitor.PulseAll(Self);
  System.TMonitor.Exit(Self);
 End;
End;

Procedure TDataListSend.AddItem(Const AItem : TDataValueSend);
Begin
 Try
  System.TMonitor.Enter(Self);
  Add(AItem);
 Finally
  System.TMonitor.PulseAll(Self);
  System.TMonitor.Exit(Self);
 End;
End;

Procedure TDataList.AddItem(Const AItem : TDataValue);
Begin
 AItem.Tries     := 0;
 Try
  System.TMonitor.Enter(Self);
  Self.Add(AItem);
  If (AItem.PackIndex = 0)   And
     (AItem.PartsTotal <= 1) Then
   AItem.PackIndex := Self.Count -1;
 Finally
  System.TMonitor.PulseAll(Self);
  System.TMonitor.Exit(Self);
 End;
End;

Procedure  TReceiveBuffers.ClearList;
Var
 I    : Integer;
Begin
 Try
  If Self <> Nil Then
   Begin
    System.TMonitor.Enter(Self);
    For I := Self.Count -1 Downto 0 Do
     Self.Delete(I);
   End;
 Finally
  If Self <> Nil Then
   Begin
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
 End;
End;

Procedure  TPeersConnected.ClearList;
Var
 I    : Integer;
Begin
 Try
  If Self <> Nil Then
   Begin
    System.TMonitor.Enter(Self);
    For I := Self.Count -1 Downto 0 Do
     Self.Delete(I);
   End;
 Finally
  If Self <> Nil Then
   Begin
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
 End;
End;

Procedure  TDataListReceive.ClearList;
Var
 I : Integer;
Begin
 If Self <> Nil Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    For I := Self.Count -1 Downto 0 Do
     Self.Delete(I);
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure  TDataListSend.ClearList;
Var
 I : Integer;
Begin
 If Self <> Nil Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    For I := Self.Count -1 Downto 0 Do
     Self.Delete(I);
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure  TDataList.ClearList;
Var
 I : Integer;
Begin
 If Self <> Nil Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    Try
     For I := Self.Count -1 Downto 0 Do
      Self.Delete(I);
    Except
    End;
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Destructor TReceiveBuffers.Destroy;
Begin
 ClearList;
 Inherited;
End;

Destructor TPeersConnected.Destroy;
Begin
 ClearList;
 Inherited;
End;

Destructor TDataListReceive.Destroy;
Begin
 ClearList;
 Inherited;
End;

Destructor TDataListSend.Destroy;
Begin
 ClearList;
 Inherited;
End;

Destructor TDataList.Destroy;
Begin
 ClearList;
 Inherited;
End;

Procedure  TPeersConnected.GetPeerInfo(Host       : String;
                                       Port       : Word;
                                       Var Result : TPeerConnected);
Var
 I : Integer;
Begin
 Result := Nil;
 If (Self.Count > 0) Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    For I := Self.Count - 1 Downto 0 Do
     Begin
      If (TPeerConnected(Self[I]).RemoteIP = Host)  And
         ((TPeerConnected(Self[I]).Port    = Port)  Or
          (TPeerConnected(Self[I]).TCPPort = Port)) Then
       Begin
        Result := TPeerConnected(Self[I]);
        Break;
       End;
     End;
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TReceiveBuffers.DeleteItem(PackID : String);
Var
 I : Integer;
Begin
 If (Self.Count > 0) Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    For I := Self.Count -1 Downto 0 Do
     Begin
      If (TReceiveBuffer(Self[I]).IdBuffer = PackID) Then
       Self.Delete(I);
     End;
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TPeersConnected.DeleteItem (Host : String; Port : Word);
Var
 I : Integer;
Begin
 If (Self.Count > 0) Then
  Begin
   System.TMonitor.Enter(Self);
   Try
    For I := Self.Count -1 Downto 0 Do
     Begin
      If (Pos(TPeerConnected(Self[I]).RemoteIP, Host) > 0) And
         ((TPeerConnected(Self[I]).Port     = Port) Or
          (TPeerConnected(Self[I]).TCPPort  = Port)) Then
       Begin
//        TPeerConnected(Self[I]).Free;
        Self.Delete(I);
        Break;
       End;
     End;
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TReceiveBuffers.DeleteItem(aItemIndex : Integer);
Begin
 If Not((Self.Count -1 < aItemIndex) Or
        (Self.Count = 0)) Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    Self.Delete(aItemIndex);
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TPeersConnected.DeleteItem(aItemIndex : Integer);
Begin
 If Not((Self.Count -1 < aItemIndex) Or
        (Self.Count = 0)) Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    Try
     Self.Delete(aItemIndex);
    Except
    End;
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Function  TDataList.GetBufferForID(Value : String) : TDataValue;
Var
 I : Integer;
Begin
 Result := Nil;
 For I := Self.Count -1 Downto 0 Do
  Begin
   If I < (Self.Count - 1) Then
    Begin
     If Self.Items[I].MD5 = Value Then
      Begin
       Result := Self.Items[I];
       Break;
      End;
    End;
  End;
End;

Procedure TDataList.DeleteItem(MD5 : String);
Var
 I : Integer;
Begin
 If (Count > 0) Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    For I := 0 to Count -1 Do
     Begin
      If Trim(Items[I].PackID) = Trim(MD5) Then
       Begin
        Self.Delete(I);
        Break;
       End;
     End;
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TDataListReceive.DeleteItem(aItemIndex : Integer);
Begin
 If Not((Count -1 < aItemIndex) Or (Count = 0)) Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    If Self.Count > 0 Then
     Self.Delete(aItemIndex);
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TDataListSend.DeleteItem(aItemIndex : Integer);
Begin
 If Not((Count -1 < aItemIndex) Or (Count = 0)) Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    If Self.Count > 0 Then
     Self.Delete(aItemIndex);
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TDataList.DeleteItem(aItemIndex : Integer);
Begin
 If Not((Count -1 < aItemIndex) Or (Count = 0)) Then
  Begin
   Try
    System.TMonitor.Enter(Self);
    If Self.Count > 0 Then
     Self.Delete(aItemIndex);
   Finally
    System.TMonitor.PulseAll(Self);
    System.TMonitor.Exit(Self);
   End;
  End;
End;

Procedure TUDPSuperClient.SendRawBuffer(Peer  : String;
                                        Port  : Word;
                                        Value : tIdBytes);
Begin
 If vClientUDP <> Nil Then
  If vClientUDP.vClientUDP <> Nil Then
   If vClientUDP.vClientUDP.Active Then
    Begin
     vClientUDP.vSendType^ := SendType;
     vClientUDP.vClientUDP.SendBuffer(Peer, Port, Value);
    End;
End;

Procedure TUDPSuperClient.SendBuffer(AData               : String;
                                     Compression         : Boolean = False;
                                     DataTransactionType : TDataTransactionType = dtt_Sync);
Begin
 If vClientUDP <> Nil Then
  Begin
   vClientUDP.vSendType^ := SendType;
   vClientUDP.AddPack(vHostIP, vHostPort, AData, Compression, ht_Server, dtString, -1, DataTransactionType);
  End;
End;

Function CompressString(Value : String) : String;
Var
 Compress   : TzCompressionStream;
 SrcStream,
 OutPut     : TStringStream;
Begin
 OutPut             := TStringStream.Create('', CompressionDecoding);
 SrcStream          := TStringStream.Create(Value, CompressionEncoding);
 OutPut.Position    := 0;
 Try
  Compress        := TzCompressionStream.Create(OutPut, zcMax);
  Compress.CopyFrom(SrcStream, 0);
  FreeAndNil(Compress);
  OutPut.Position := 0;
  Result          := OutPut.DataString;
  FreeAndNil(OutPut);
  FreeAndNil(SrcStream);
 Except
 End;
End;

Function CompressStream(Value : TIdBytes; Var Dest : TIdBytes) : Integer;
Var
 Compress   : TzCompressionStream;
 SrcStream,
 OutPut     : TMemoryStream;
Begin
 OutPut             := TMemoryStream.Create;
 SrcStream          := TMemoryStream.Create;
 Try
//  SrcStream.Write(Value[0], Length(Value));
  WriteTIdBytesToStream(SrcStream, Value, Length(Value), 0);
  SrcStream.Position := 0;
  OutPut.Position    := 0;
  Compress        := TzCompressionStream.Create(OutPut, zcMax);
  Compress.CopyFrom(SrcStream, SrcStream.Size);
  FreeAndNil(Compress);
  OutPut.Position := 0;
  Result          := OutPut.Size;
  SetLength(Dest, OutPut.Size);
  ReadTIdBytesFromStream(OutPut, Dest, Result, 0);
//  OutPut.Read(Dest[0], OutPut.Size);
 Except
 End;
 FreeAndNil(OutPut);
 FreeAndNil(SrcStream);
End;

Function CompressString(Value : String; Var DataSize : Integer) : String;
Var
 Compress   : TzCompressionStream;
 SrcStream,
 OutPut     : TStringStream;
Begin
 OutPut             := TStringStream.Create('', CompressionDecoding);
 SrcStream          := TStringStream.Create(Value, CompressionEncoding);
 OutPut.Position    := 0;
 Try
  Compress        := TzCompressionStream.Create(OutPut, zcDefault);
  Compress.CopyFrom(SrcStream, SrcStream.Size);
  FreeAndNil(Compress);
  OutPut.Position := 0;
  Result          := OutPut.DataString;
  DataSize        := OutPut.Size;
  FreeAndNil(OutPut);
  FreeAndNil(SrcStream);
 Except
 End;
End;

Function DecompressStream(Value    : TIdBytes;
                          Var Dest : TIdBytes) : Integer;
Var
 DeCompress : TZDecompressionStream;
 SrcStream,
 OutPut     : TMemoryStream;
 vDataSize  : Integer;
Begin
 Result              := 0;
 OutPut              := TMemoryStream.Create;
 WriteTIdBytesToStream(OutPut, Value, Length(Value), 0);
// OutPut.Write(Value[0], Length(Value));
 OutPut.Position := 0;
 SrcStream           := TMemoryStream.Create;
 OutPut.Position     := 0;
 DeCompress          := TZDecompressionStream.Create(OutPut);
 Try
  vDataSize          := DeCompress.Size;
  SrcStream.CopyFrom(DeCompress, vDataSize);
  SetLength(Dest, vDataSize);
  SrcStream.Position := 0;
  ReadTIdBytesFromStream(SrcStream, Dest, vDataSize, 0);
//  SrcStream.Read(Dest[0], vDataSize);
  Result := Length(Dest);
 Except

 End;
 FreeAndNil(DeCompress);
 FreeAndNil(OutPut);
 FreeAndNil(SrcStream);
End;

Function DecompressString(Value : String) : String;
Var
 DeCompress : TZDecompressionStream;
 SrcStream,
 OutPut     : TStringStream;
Begin
 OutPut              := TStringStream.Create(Value, CompressionEncoding);
 SrcStream           := TStringStream.Create('',    CompressionDecoding);
 OutPut.Position     := 0;
 Result              := '';
 Try
  DeCompress         := TZDecompressionStream.Create(OutPut);
  SrcStream.CopyFrom(DeCompress, DeCompress.Size);
  FreeAndNil(DeCompress);
  FreeAndNil(OutPut);
  SrcStream.Position := 0;
  Result             := SrcStream.DataString;
  FreeAndNil(SrcStream);
 Except

 End;
End;

Procedure TUDPSuperClient.BroadcastBuffer(AData       : String;
                                          Compression : Boolean = False);
Var
 I         : Integer;
 vHostData : String;
 AItem     : TPeerConnected;
Begin
 If vPeersConnected.Count > 0 Then
  Begin
   For I := 0 to vPeersConnected.Count -1 Do
    Begin
     If (TPeerConnected(vPeersConnected[I]).RemoteIP <> vHostIP) And
        ((TPeerConnected(vPeersConnected[I]).Port    <> vHostPort) And
         (TPeerConnected(vPeersConnected[I]).TCPPort <> vHostPort))   Then
      Begin
       vHostData := TPeerConnected(vPeersConnected[I]).RemoteIP;
       If vMyOnLineIP = vHostData Then
        Begin
         vPeersConnected.GetPeerInfo(vHostData, Port, AItem);
         If AItem <> Nil Then
          vHostData := AItem.LocalIP;
        End;
       If vHostData = '' Then
        vHostData := TPeerConnected(vPeersConnected[I]).RemoteIP;
       vClientUDP.AddPack(vHostData,
                          TPeerConnected(vPeersConnected[I]).Port, 
                          AData, Compression, ht_Client, dtBroadcastString);
      End;
    End;
  End;
End;

Function TUDPSuperClient.ReceiveString(Milis : Word = 0) : String;
Var
 Event : TEvent;
 vNow  : TDateTime;
Begin
 Try
  Event := TEvent.Create(nil, True, False, 'ReceiveString');
  If Milis > 0 Then
   Begin
    vNow := Now;
    While (MilliSecondsBetween(Now, vNow) <= Milis) Do
     Begin
      Result := vBufferCapture; //.Value;
      If Result <> '' Then
       Break
      Else
       Event.WaitFor(TReceiveTimeThread);
     End;
    If Result = '' Then
     Result := vBufferCapture; //.Value;
   End
  Else If vConnected Then
   Begin
    Result := vBufferCapture; //.Value;
    While vConnected And (Result = '') Do
     Begin
      Event.WaitFor(TReceiveTimeThread);
      Result := vBufferCapture; //.Value;
     End;
   End;
 Finally
  If Result = vBufferCapture Then
   vBufferCapture := '';
  Event.Free;
 End;
End;

Procedure TUDPSuperClient.SetOnGetLongString(Value : TOnGetLongString);
Begin
 vOnGetLongString := Value;
 If (vClientUDP <> Nil) Then
  vClientUDP.vOnGetLongString := vOnGetLongString;
End;

Procedure TUDPSuperClient.SetOnGetData(Value : TOnGetData);
Begin
 vOnGetData := Value;
 If (vClientUDP <> Nil) Then
  vClientUDP.vOnGetData := vOnGetData;
End;

Procedure TUDPSuperClient.AbortSendOperation;
Begin
 AbortSend      := True;
 vLastBufferCon := '';
 Try
  If (vClientUDP <> Nil) Then
   Begin
    If (vClientUDP.vListSend <> Nil) Then
     vClientUDP.vListSend.ClearList;
   End;
 Except

 End;
End;

Function TUDPSuperClient.AddPeer(Var AItem  : TPeerConnected) : Boolean;
Begin
 Result := vPeersConnected.AddPeer(AItem);
 {
 If Assigned(Server) Then
  Begin
   If Server^ <> Nil Then
    Result := vPeersConnected.AddPeer(AItem);
  End;
 }
 If Not Result Then
  If AItem <> Nil Then
   AItem.Free;
End;

Procedure TUDPSuperClient.QueryFinished(Sender : TObject);
Begin
 If ConnectPeerThread <> Nil Then
  Begin
   ConnectPeerThread.Kill;
   WaitForSingleObject(ConnectPeerThread.Handle, 100);
//   FreeAndNil(ConnectPeerThread);
   ConnectPeerThread := Nil;
  End;
End;

Procedure TUDPSuperClient.ConnectPeer(Peer,
                                      Local     : String;
                                      Port,
                                      LocalPort : Word);
Var
 vBufferID,
 vLastBuffer : String;
 A, I        : Integer;
 vWaitFor    : Boolean;
Begin
 If (ConnectPeerThread <> Nil) Then
  Begin
   Try
    ConnectPeerThread.Kill;
   Except
   End;
   WaitForSingleObject(ConnectPeerThread.Handle, TThreadWaitDead);
   ConnectPeerThread := Nil;
   FreeAndNil(ConnectPeerThread);
  End;
 If ConnectPeerThread = Nil Then
  Begin
   vOpenTrans     := False;
   vWaitFor       := False;
   vLastBuffer    := Format(TConnectPeerInfo, [vMyOnLineIP + '|' + LocalIP + ':' + IntToStr(vMyOnlinePort) + '!' + IntToStr(vMyPort),
                                               Peer        + '|' + Local   + ':' + IntToStr(Port)          + '!' + IntToStr(LocalPort)]);
   If vLastBufferCon = vLastBuffer Then
    Exit;
   AbortSendOperation;
   vLastBufferCon := vLastBuffer;
   vBufferID := vClientUDP.AddPack(Peer, Port, vLastBuffer, False, ht_Server);
   ConnectPeerThread                 := TThreadConnection.Create(vLastBuffer + TDelimiter + vBufferID,
                                                                 @vPeerConnectionOK,   vPeerConnectionTimeOut,
                                                                 @TObject(vClientUDP), vOnConnectionPeerTimeOut,
                                                                 @vPeersConnected);
   ConnectPeerThread.OnTerminate     := QueryFinished;
   ConnectPeerThread.FreeOnTerminate := True;
   ConnectPeerThread.Priority        := tpLowest;
   ConnectPeerThread.Resume;
  End;
End;

Function  TUDPSuperClient.GetActivePeer : TPeerConnected;
Var
 I : Integer;
Begin
 Result := Nil;
 If vPeersConnected.Count > 0 Then
  Begin
   For I := vPeersConnected.Count -1 Downto 0 Do
    Begin
     If TPeerConnected(vPeersConnected[I]).TransactionOpen Then
      Begin
       Result := TPeerConnected(vPeersConnected[I]);
       Exit;
      End;
    End;
  End;
End;

Procedure TUDPSuperClient.GetPeerInfo(Peer : String;
                                      Port : Word);
Begin
 If vClientUDP <> Nil Then
  vClientUDP.AddPack(Peer, Port, Format(TGetPeerInfoPackData, [Peer, IntToStr(Port)]), False, ht_Server);
End;

Procedure TUDPSuperClient.SendBinary(Peer                : String;
                                     Port                : Word;
                                     AData               : TIdBytes;
                                     Compression         : Boolean = False;
                                     DataTransactionType : TDataTransactionType = dtt_Sync);
Var
 vBufferString,
 vLastBufferID,
 vHostData     : String;
 vBuffValue,
 vCompressData : TIdBytes;
 AItem         : TPeerConnected;
 vPackCopy,
 vSTREAM_SIZE,
 vPackSize,
 vSizeString   : Integer;
 vInitBuffer,
 vFinalBuffer  : Boolean;
Begin
 vHostData     := Peer;
 AbortSend     := False;
 If Compression Then
  CompressStream(AData, vCompressData)
 Else
  Begin
   SetLength(vCompressData, Length(AData));
   Move(AData[0], vCompressData[0], Length(AData));
  End;
 vPackSize      := Length(vCompressData);
 If vClientUDP <> Nil Then
  Begin
   If vMyOnLineIP = vHostData Then
    Begin
     vPeersConnected.GetPeerInfo(vHostData, Port, AItem);
     If AItem <> Nil Then
      vHostData := AItem.LocalIP;
    End
   Else
    vPeersConnected.GetPeerInfo (Peer,      Port, AItem);
   If vHostData = '' Then
    vHostData := Peer;
   vSTREAM_SIZE := (vBufferSize div 2) - (1024 * 3);
   vPackCopy    := 0;
   Try
    vFinalBuffer := False;
    vInitBuffer  := True;
    While vPackCopy < vPackSize Do
     Begin
      If ((vPackCopy + vSTREAM_SIZE) < vPackSize) Then
       SetLength(vBuffValue, vSTREAM_SIZE)
      Else
       Begin
        vFinalBuffer  := True;
        SetLength(vBuffValue, Length(vCompressData) - vPackCopy);
       End;
      Move(vCompressData[vPackCopy], vBuffValue[0], Length(vBuffValue));
      vLastBufferID := vClientUDP.AddPack(Peer, Port,   vBuffValue, Compression, ht_client,
                                          dtDataStream, vPackSize,  DataTransactionType, vPackCopy,
                                          Length(vBuffValue), vInitBuffer, vFinalBuffer);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
      vPackCopy   := vPackCopy + Length(vBuffValue);
      vInitBuffer := False;
      SetLength(vBuffValue, 0);
     End;
   Finally
    If DataTransactionType = dtt_Sync Then
     WaitTerminateEvent(vLastBufferID);
   End;
  End;
End;

Procedure TUDPSuperClient.SendLongBuffer(Peer                : String;
                                         Port                : Word;
                                         AData               : String;
                                         Compression         : Boolean = False;
                                         DataTransactionType : TDataTransactionType = dtt_Sync);
Var
 vPeerReturn,
 vTransactionData,
 vTempString,
 vBufferString,
 vInitBufferID,
 vLastBufferID,
 vHostData,
 vCompressData : String;
 AItem         : TPeerConnected;
 A,
 vPortReturn,
 vPartsTotal,
 vSTREAM_SIZE,
 vPackNum,
 vPackSize,
 vSizeString   : Integer;
 vInitBuffer   : Boolean;
 DataPack      : TDataPack;
 vTempBuffer   : TIdBytes;
 Function GetParts(PackSize, StreamSize : Integer) : Integer;
 Var
  vBufferParts : Integer;
 Begin
  Result       := 0;
  vBufferParts := 0;
  While vBufferParts <= PackSize Do
   Begin
    vBufferParts := vBufferParts + StreamSize;
    Inc(Result);
   End;
 End;
Begin
 vHostData     := Peer;
 AbortSend     := False;
 vInitBuffer   := True;
 If Compression Then
  vCompressData := CompressString(AData, vPackSize)
 Else
  vCompressData := AData;
 vInitBufferID  := '';
 vPackSize      := Length(vCompressData);
 vTempString    := Format(TBufferInfo,  [vCompressData]);
 vPackNum       := 0;
 If vClientUDP <> Nil Then
  Begin
   If vMyOnLineIP = vHostData Then
    Begin
     vPeersConnected.GetPeerInfo(vHostData, Port, AItem);
     If AItem <> Nil Then
      vHostData := AItem.LocalIP;
    End
   Else
    vPeersConnected.GetPeerInfo (Peer,      Port, AItem);
   If vHostData = '' Then
    vHostData := Peer;
   vSTREAM_SIZE := vBufferSize - 512;//(vBufferSize div 2) - (1024 * 3);
   vPartsTotal  := GetParts(vPackSize, vSTREAM_SIZE);
   Try
    While vTempString <> '' Do
     Begin
      vSizeString  := Length(vTempString);
      If vSizeString > vSTREAM_SIZE Then
       Begin
        vBufferString       := Copy(vTempString, 1, vSTREAM_SIZE);
        Delete(vTempString, 1, vSTREAM_SIZE);
       End
      Else
       Begin
        vBufferString       := vTempString;
        vTempString         := '';
       End;
      vClientUDP.vSendType^ := SendType;
      vLastBufferID := vClientUDP.AddPack(Peer, Port,    vBufferString, Compression, ht_client,
                                          dtBytes,       vPackSize,     DataTransactionType,
                                          vInitBufferID, vPackNum,      vPartsTotal);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
      If vInitBuffer Then
       Begin
        vInitBufferID := vLastBufferID;
        vInitBuffer   := False;
       End;
      Inc(vPackNum);
     End;
   Finally
    If DataTransactionType = dtt_Sync Then
     WaitTerminateEvent(vLastBufferID);
   End;
  End;
End;

Procedure TUDPSuperClient.SendRawString(Peer                : String;
                                        Port                : Word;
                                        AData               : String;
                                        Compression         : Boolean = False;
                                        SendPacks           : Integer = 1);
Var
 vHostData : String;
 AItem     : TPeerConnected;
 I         : Integer;
Begin
 vHostData := Peer;
 If vClientUDP <> Nil Then
  Begin
   If vMyOnLineIP = vHostData Then
    Begin
     vPeersConnected.GetPeerInfo(vHostData, Port, AItem);
     If AItem <> Nil Then
      vHostData := AItem.LocalIP;
    End;
   If vHostData = '' Then
    vHostData := Peer;
   For I := 0 To SendPacks -1 Do
    vClientUDP.AddPack(vHostData,    Port,  AData,
                       Compression,     ht_Client,
                       dtRawString, -1, dtt_aSync);
   {$IFDEF MSWINDOWS}
   {$IFNDEF FMX}Application.Processmessages;
         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
   {$ENDIF}
  End;
End;

Procedure TUDPSuperClient.SendBuffer(Peer                : String;
                                     Port                : Word;
                                     AData               : String;
                                     Compression         : Boolean = False;
                                     DataTransactionType : TDataTransactionType = dtt_Sync);
Var
 vHostData : String;
 AItem     : TPeerConnected;
Begin
 vHostData := Peer;
 If vClientUDP <> Nil Then
  Begin
   If vMyOnLineIP = vHostData Then
    Begin
     vPeersConnected.GetPeerInfo(vHostData, Port, AItem);
     If AItem <> Nil Then
      vHostData := AItem.LocalIP;
    End;
   If vHostData = '' Then
    vHostData := Peer;
   vClientUDP.AddPack(vHostData, Port, AData, Compression, ht_Client,
                      dtString, -1,    DataTransactionType);
   {$IFDEF MSWINDOWS}
   {$IFNDEF FMX}Application.Processmessages;
         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
   {$ENDIF}
  End;
End;

Function TUDPSuperClient.WaitConnectionEvent(BufferID : String) : Boolean;
Var
 vNow           : TDateTime;
 Host,
 LocalHost      : String;
 Port           : Integer;
 vResult,
 vBreak         : Boolean;
 vPeerConnected : TPeerConnected;
Begin
 Result := False;
 vPeerConnectionOK := False;
 Try
  AbortSend  := False;
  vNow := Now;
  BufferID   := Copy(BufferID, Pos(TDelimiter, BufferID) + Length(TDelimiter), Length(BufferID));
  Host       := Copy(BufferID, 1, Pos('|', BufferID) -1);
  Delete(BufferID, 1, Pos('|', BufferID));
  LocalHost  := Copy(BufferID, 1, Pos(':', BufferID) -1);
  Delete(BufferID, 1, Pos(':', BufferID));
  Port       := StrToInt(Copy(BufferID, 1, Pos('!', BufferID) -1));
  Delete(BufferID, 1, Length(BufferID));
  vBreak  := False;
  vResult := False;
  While (vClientUDP.vClientUDP <> Nil) And (Not (AbortSend)) And (Not (vPeerConnectionOK)) And (Not (vBreak)) Do
   Begin
    ConnectPeerThread.Synchronize(Procedure
                                  Begin
                                   If (vClientUDP <> Nil) Then
                                    Begin
                                     If (MilliSecondsBetween(Now, vNow) > vPeerConnectionTimeOut) Then
                                      Begin
                                       vPeersConnected.GetPeerInfo(Host, Port, vPeerConnected);
                                       If vPeerConnected <> Nil Then
                                        Begin
                                         vPeerConnected.TransactionOpen := False;
                                         vPeerConnected.Connected       := False;
                                        End;
                                       If Assigned(vOnConnectionPeerTimeOut) Then
                                        vOnConnectionPeerTimeOut  (Host, LocalHost, Port);
                                       vBreak := True;
                                      End
                                     Else
                                      Begin
                                       vPeersConnected.GetPeerInfo(Host, Port, vPeerConnected);
                                       If vPeerConnected <> Nil Then
                                        If (vPeerConnected.Connected)       And
                                           (vPeerConnected.TransactionOpen) Then
                                         Begin
                                          vPeerConnectionOK := True;
                                          vResult := True;
                                          vBreak  := True;
                                         End;
                                      End;
                                    End
                                   Else
                                    vBreak := True;
                                   If vClientUDP.FTerminateEvent <> Nil Then
                                    vClientUDP.FTerminateEvent.WaitFor(TDelayThread);
                                   {$IFDEF MSWINDOWS}
                                   {$IFNDEF FMX}Application.Processmessages;
                                         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
                                   {$ENDIF}
                                  End);
   End;
 Except
 End;
 Result            := vResult;
 AbortSend         := False;
End;

Procedure TUDPSuperClient.SetTextEncoding(Value : IdTextEncodingType);
Begin
 vIdTextEncodingType := Value;
 Case Value Of
  encIndyDefault,
  encOSDefault,
  encUTF16BE,
  encUTF16LE,
  encUTF7, encUTF8  :
   Begin
    vTextEncoding       := IndyTextEncoding_UTF8;
    CompressionEncoding := TEncoding.UTF8;
   End;
  enc8Bit, encASCII :
   Begin
    vTextEncoding       := IndyTextEncoding_ASCII;
    CompressionEncoding := TEncoding.ANSI;
   End;
 End;
 vGeralEncode := vTextEncoding;
End;

Procedure TUDPSuperClient.WaitTerminateEvent(BufferID : String);
Begin
 Try
  While (vClientUDP.vClientUDP <> Nil) And   (Not (AbortSend)) Do
   Begin
    If (vClientUDP <> Nil) Then
     Begin
      If (vClientUDP.vListSend.GetBufferForID(BufferID) = Nil) Then
       Break;
      If (vClientUDP.vClientUDP.Active) Then
       Begin
        If vClientUDP.FTerminateEvent <> Nil Then
         vClientUDP.FTerminateEvent.WaitFor  (TDelayThread);
       End;
     End
    Else
     Break;
    {$IFDEF MSWINDOWS}
    {$IFNDEF FMX}Application.Processmessages;
          {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
    {$ENDIF}
   End;
 Except
 End;
 AbortSend := False;
End;

Procedure TUDPSuperClient.DataPeerInfo(Value : String);
Var
 AItem2,
 aItem : TPeerConnected;
 vTempLine,
 vHost : String;
 vPort : Integer;
Begin
 aItem     := Nil;
 vTempLine := Copy(Value, Pos(TGetIp, Value), Length(Value));
 vHost     := Copy(vTempLine, Pos(TGetIp, vTempLine)                 + Length(TGetIp),     Pos(TDelimiter, vTempLine) - Length(TGetIp)   - 1);
 vTempLine := Copy(vTempLine, Pos(TDelimiter, vTempLine)             + Length(TDelimiter), Length(vTempLine));
 vPort     := StrToInt(Copy(vTempLine, Pos(TGetPort, vTempLine)      + Length(TGetPort),   Pos(TDelimiter, vTempLine) - Length(TGetPort) - 1));
 If Not(Pos(TPeerNoData, Value) > 0) Then
  Begin
   vTempLine      := Copy(vTempLine, Pos(TDelimiter, vTempLine)      + Length(TDelimiter), Length(vTempLine));
   aItem          := TPeerConnected.Create;
   aItem.RemoteIP := vHost;
   aItem.Port     := vPort;
   aItem.LocalIP  := Copy(vTempLine, Pos(TMyLocalIPInit, vTempLine)  +
                                     Length(TMyLocalIPInit),
                                     Pos(TMyLocalIPFinal, vTempLine) - Length(TMyLocalIPInit) - 1);
  End;
 If Pos(TPeerNoData, Value) > 0 Then
  Begin
   If Assigned(vOnGetPeerInfo)  Then
    vOnGetPeerInfo(vHost, vPort, aItem);
  End
 Else
  Begin
   vPeersConnected.GetPeerInfo(aItem.RemoteIP, aItem.Port, AItem2);
   If AItem2 = Nil Then
    Begin
     If Assigned(vOnGetPeerInfo) Then
      vOnGetPeerInfo(vHost, vPort, aItem);
    End;
  End;
 If (aItem <> Nil) Then
  aItem.Free;
End;

Procedure TUDPSuperClient.SetConnected(Value : Boolean);
 Procedure WaitActiveEvent;
 Begin
  While (vClientUDP.vClientUDP <> Nil) And (Not (AbortSend)) And (Not Active) Do
   Begin
    Try
     If (vClientUDP = Nil) Then
      Break;
     If vClientUDP.FTerminateEvent <> Nil Then
      vClientUDP.FTerminateEvent.WaitFor(TReceiveTimeThread)
     Else
      Sleep(TReceiveTimeThread);
     {$IFDEF MSWINDOWS}
     {$IFNDEF FMX}Application.Processmessages;
           {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
     {$ENDIF}
    Except
    End;
   End;
  AbortSend := False;
 End;
Begin
 vPeerConnectionOK := False;
 If (ConnectPeerThread <> Nil) Then
  Begin
   Try
    ConnectPeerThread.Kill;
   Except
   End;
   WaitForSingleObject(ConnectPeerThread.Handle, TThreadWaitDead);
   ConnectPeerThread := Nil;
   FreeAndNil(ConnectPeerThread);
  End;
 If (vClientUDP <> Nil) Then
  Begin
   Try
    AbortSendOperation;
    vClientUDP.Kill;
   Except
   End;
   WaitForSingleObject(vClientUDP.Handle, TThreadWaitDead);
   vClientUDP := Nil;
   FreeAndNil(vClientUDP);
   vConnected := False;
   If (vPeersConnected <> Nil)  Then
    vPeersConnected.ClearList;
   If Assigned(vOnDisconnected) Then
    vOnDisconnected;
  End;
 If (Value) Then
  Begin
   New(Server);
   vOpenTrans := False;
   vClientUDP := TUDPClient.Create(Self,          vTransparentProxy,
                                   vHostIP,       vHostPort,
                                   vTimeOut,      vRetryPacks,
                                   vOnError,      vOnGetData,
                                   vOnConnected,  vOnTimer,
                                   vOnPeerConnected,
                                   vOnPeerRemoteConnect,
                                   vOnGetLongString,
                                   vOnDataIn,
                                   vOnBinaryIn,
                                   @vInternalTimer,
                                   @vConnected,   @vBufferCapture,
                                   @vMyOnLineIP,  @vMilisTimer,
                                   @vMyPort,      @vMyOnlinePort,
                                   @vBufferSize,  @vPeersConnected,
                                   vWelcome,      vTextEncoding,
                                   vIPVersion,    vDataPeerInfo,
                                   Server,        vRequestAlive,
                                   vSyncTimerInterface,
                                   @vSendType,    Self,
                                   @vPeerConnectionOK,
                                   vTCPPort,
                                   @vOpenTrans);
   vClientUDP.Resume;
   WaitActiveEvent;
  End;
End;

Constructor TUDPSuperClient.Create(AOwner : TComponent);
Begin
 Inherited;
// vBufferCapture  := TIdThreadSafeString.Create;
 vOwner                   := AOwner;
 vIdTextEncodingType      := encASCII;
 vTextEncoding            := IndyTextEncoding_ASCII;
// CompressionEncoding      := TEncoding.UTF8;
 vGeralEncode             := vTextEncoding;
 vSendType                := stNAT;
 vMyOnLineIP              := '';
 vMyPort                  := 0;
 vRetryPacks              := TRetryPacks;
 vTimeOut                 := TReceiveTimeOut;
 vPeerConnectionTimeOut   := 5000;
 vMilisTimer              := 1000;
 vBufferSize              := BUFFER_SIZE;
 vInternalTimer           := False;
 vPeersConnected          := TPeersConnected.Create;
 vIPVersion               := id_IPv4;
 vDataPeerInfo            := DataPeerInfo;
 vTransparentProxy        := TIdSocksInfo.Create(Self);
 vRequestAlive            := False;
 vSyncTimerInterface      := False;
 ConnectPeerThread        := Nil;
End;

Destructor  TUDPSuperClient.Destroy;
Begin
 SetConnected(False);
 vPeersConnected.ClearList;
 vPeersConnected.Free;
 vTransparentProxy.Free;
 vTextEncoding := Nil;
// vBufferCapture.Free;
 Inherited;
End;

Procedure TUDPClient.GetData;
Var
 vGetDataI,
 vGetDataSize,
 vGetDataD      : TIdBytes;
 vStringReceive : String;
 vIndex,
 vIndexSize,
 vBufferSizeD   : Integer;
Begin
 If vOnGet Then
  Exit
 Else
  vOnGet := True;
 Try
  If vClientUDPReceive = Nil Then
   Begin
    Try
     If vClientUDP <> Nil Then
      Begin
       If vClientUDP.Active Then
        Begin
         If vClientUDP <> Nil Then
          Begin
           If OnPunch Then
            Exit;
           If (vSendType^ = stProxy) And
              (vTCPPort   > 0)       And
              (vTCPClient.Connected) Then
            Begin
//             vTCPClient.IOHandler.Readable()
             If vTCPClient.IOHandler.InputBuffer.Size > 0 Then
              vTCPClient.IOHandler.InputBuffer.ExtractToBytes(vGetDataI);
//              SetLength(vGetDataI, vTCPClient.IOHandler.InputBuffer.Size);
             vBufferSizeD := Length(vGetDataI);
            End
           Else
            Begin
             SetLength(vGetDataI, vClientUDP.BufferSize);
             vBufferSizeD := vClientUDP.ReceiveBuffer(vGetDataI, TReceiveTime);
             If vBufferSizeD = 0 Then
              SetLength(vGetDataI, 0);
            End;
          End;
         {$IFDEF MSWINDOWS}
         {$IFNDEF FMX}Application.Processmessages;
               {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
         {$ENDIF}
         If vBufferSizeD > 0 Then
          Begin
           vIndex := 0;
           If (vSendType^ = stProxy) Then
            Begin
//              SetLength(vGetDataSize, 0);
             SetLength(vGetDataSize, SizeOf(Integer));
             Move(vGetDataI[vIndex], vGetDataSize[0], SizeOf(Integer));
             vIndexSize := BytesToInt16(vGetDataSize);
             vIndex     := vIndex + SizeOf(Integer);
             SetLength(vGetDataD, vIndexSize);
             Move(vGetDataI[vIndex], vGetDataD[0], vIndexSize);
//              SetLength(vGetDataI, 0);
             If DataListReceive <> Nil Then
              DataListReceive.AddValue(vGetDataD);
             SetLength(vGetDataD, 0);
             vBufferSizeD := vBufferSizeD - vIndexSize - SizeOf(Integer);
             If vBufferSizeD > 0 Then
              vIndex := vIndex + vIndexSize;
            End
           Else
            Begin
             SetLength(vGetDataD, vBufferSizeD);
             Move(vGetDataI[0], vGetDataD[0], vBufferSizeD);
             SetLength(vGetDataI, 0);
             If DataListReceive <> Nil Then
              DataListReceive.AddValue(vGetDataD);
            End;
          End
         Else
          SetLength(vGetDataI, 0);
         SetLength(vGetDataD, 0);
        End;
      End;
    Except

    End;
   End;
 Finally
  FTerminateEvent.WaitFor(TReceiveTimeThread);
  vOnGet := False;
 End;
End;

Procedure TUDPClient.SendPing;
Var
 vTransactionData,
 vPeerReturn  : String;
 vPortReturn  : Word;
 DataPackTemp : TDataPack;
Begin
 If (vClientUDP <> Nil) Then
  Begin
   vPeerReturn        := vHostIP;
   vPortReturn        := vHostPort;
   If vClientUDP.Active Then
    Begin
     BuildDataPack(vMyOnLineIP^,      vPeerReturn,  vMyOnlinePort^, vPortReturn,
                   Format(TSendPing + '%s|%s:%d',  [vMyOnLineIP^,   LocalIP,     vMyOnlinePort^]),
                   dtString, DataPackTemp);
     RawBytesPack    (DataPackTemp, vTransactionData);
     If ProcessDataThread = Nil Then
      vClientUDP.SendBuffer(vPeerReturn,      vPortReturn,
                            ToBytes(vTransactionData, vCodificao))
     Else
      vClientUDPSend.SendBuffer(vPeerReturn,      vPortReturn,
                                ToBytes(vTransactionData, vCodificao));
     If ProcessDataThread = Nil Then
      Begin
       {$IFDEF MSWINDOWS}
       {$IFNDEF FMX}Application.Processmessages;
             {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
       {$ENDIF}
      End;
    End;
  End;
End;

Procedure TUDPClient.GetPeer(Var Result : TPeerConnected; Host : String; Port : Integer);
Var
I : Integer;
Begin
 Result := Nil;
 If vPeersConnected <> Nil Then
  Begin
   Try
    System.TMonitor.Enter(vPeersConnected^);
    For I := vPeersConnected^.Count - 1 Downto 0 Do
     Begin
      If (TPeerConnected(vPeersConnected^[I]).RemoteIP = vHostIP)   And
         ((TPeerConnected(vPeersConnected^[I]).Port    = vHostPort) Or
          (TPeerConnected(vPeersConnected^[I]).TCPPort = vHostPort)) Then
       Continue;
      If ((Host = TPeerConnected(vPeersConnected^[I]).RemoteIP)  Or
          (Host = TPeerConnected(vPeersConnected^[I]).LocalIP))  And
         ((Port  = TPeerConnected(vPeersConnected^[I]).Port)     Or
          (Port  = TPeerConnected(vPeersConnected^[I]).TCPPort)) Then
       Begin
        Result := TPeerConnected(vPeersConnected^[I]);
        Break;
       End;
     End;
   Finally
    System.TMonitor.PulseAll(vPeersConnected^);
    System.TMonitor.Exit(vPeersConnected^);
   End;
  End;
End;

Function TUDPClient.NegociateTransaction(Client : TIdUDPClient;
                                         Value  : TDataValue) : Boolean;
Var
 vPortReturn      : Word;
 I                : Integer;
 vTransactionData,
 vBufferSend,
 vPeerReturn,
 vHolePunch       : String;
 IcmpClient       : ^TIdUDPClient;
 PeerConnected    : TPeerConnected;
 DataPack         : TDataPack;
 vTempBuffer      : TIdBytes;
Begin
 //Verifica se estou enviando para o Host Remoto
 Result := (Value.HostSend = vHostIP) And (Value.PortSend = vHostPort);
 If Result Then
  Exit;
 Try
  Try
   vHolePunch   := vGeralEncode.GetString(Value.aValue); //BytesToString(Value, vCodificao);
  Except
   vHolePunch   := CompressionDecoding.GetString(TBytes(Value.aValue));
  End;
  DataPack     := BytesDataPack(vHolePunch, vCodificao);
  If (Pos(TPunchOKString, vHolePunch) > 0) Or
     (Pos(TPeerConnect, vHolePunch) > 0)   Then
   Begin
    Result := True;
    Exit;
   End;
  //Verifica se o Peer Remoto foi adicionado antes
  If Value.DataTransactionType = dtt_direct then
   Begin
    Result := True;
    Exit;
   End;
  GetPeer(PeerConnected, Value.HostSend, Value.PortSend);
  If (PeerConnected = Nil) Then
   Exit;
  //Verifica se o Peer j� foi conectado antes
  Result := (PeerConnected.TransactionOpen) Or (PeerConnected.Connected);
  If Result Then
   Exit;
  //Verifica se j� tentou o m�ximo as reconex�es no peer
  If PeerConnected.RetriesTransaction = PeerConnected.vMaxRetriesPeerCon Then
   Exit;
  If PeerConnected.RetriesTransaction = 0 Then
   PeerConnected.LastNegociateCheck  := Now
  Else If (MilliSecondsBetween(Now, PeerConnected.LastNegociateCheck) > TPunchTimeOut) Then
   PeerConnected.LastNegociateCheck  := Now
  Else
   Exit;
  Inc(PeerConnected.RetriesTransaction);
  If Not(PeerConnected.Punch) Then
   Begin
    PeerConnected.Punch := True;
    If ((PeerConnected.RemoteIP = vMyOnLineIP^)         And
        (MyIpClass(LocalIP, vIPVersion) =
         MyIpClass(PeerConnected.LocalIP, vIPVersion))) And
       ((PeerConnected.LocalIP <> '') And
       (PeerConnected.LocalIP  <> '0.0.0.0'))           Then
     vPeerReturn                 := PeerConnected.LocalIP
    Else
     vPeerReturn                 := PeerConnected.RemoteIP;
    vPortReturn                  := PeerConnected.Port;
    vBufferSend                  := Format('%s%s', [TPunchString, vMyOnLineIP^ + '|' + LocalIP + ':' + IntToStr(vMyOnlinePort^)]);
    OnPunch                      := True;
    IcmpClient                   := @Client;
    If (TSendType(Integer(vSendType^)) = stProxy) Then
     Begin
      DataPack.aValue              := tIdBytes(CompressionDecoding.GetBytes(vBufferSend));
      DataPack.SendType            := Integer(vSendType^);
      DataPack.vHostSend           := vPeerReturn + ':' + IntToStr(vPortReturn);
      DataPack.MD5                 := GenBufferID;
      DataPack.vHostDest           := vMyOnLineIP^ + ':' + IntToStr(vMyOnlinePort^);
      RawBytesPack(DataPack, vTransactionData);
      StrToByte(vTransactionData, vTempBuffer, stProxy);
     End
    Else
     StrToByte(vBufferSend, vTempBuffer);
    If (TSendType(DataPack.SendType) = stNAT) Then
     Begin
      For I := 0 To MaxPunchs - 1 Do
       Begin
        Try
//         If (TSendType(DataPack.SendType) = stProxy) Then
//          Begin
//           If (vTCPPort > 0) And (vTCPClient.Connected) Then
//            vTCPClient.Socket.WriteDirect(vTempBuffer, Length(vTempBuffer));
//          End
//         Else
//          Begin
           If IcmpClient^.Active Then
            IcmpClient^.SendBuffer(vPeerReturn, vPortReturn, vTempBuffer); //tIdBytes(CompressionDecoding.GetBytes(vBufferSend)));
           If ProcessDataThread = Nil Then
            Begin
             {$IFDEF MSWINDOWS}
             {$IFNDEF FMX}Application.Processmessages;
                   {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
             {$ENDIF}
            End;
//          End;
         FTerminateEvent.WaitFor(TReceiveTimeThread);
        Except
        End;
       End;
     End
    Else
     Begin
      If (vTCPPort > 0) And (vTCPClient.Connected) Then
       Begin
//        vTCPClient.IOHandler.Write(vTempBuffer, Length(vTempBuffer));
        vTCPClient.Socket.WriteDirect(vTempBuffer, Length(vTempBuffer));
        vTCPClient.Socket.WriteBufferFlush;
       End;
     End;
    PeerConnected.Punch := False;
   End;
 Except
 End;
 OnPunch := False;
End;

Destructor TThreadConnection.Destroy;
Begin
 FTerminateEvent.SetEvent;
 FTerminateEvent.Free;
 Inherited;
End;

Destructor TProcessDataThread.Destroy;
Begin
 FTerminateEvent.SetEvent;
 FTerminateEvent.Free;
 Inherited;
End;

Constructor TThreadConnection.Create(BufferID                : String;
                                     vPeerConnectionOK       : PConnected;
                                     vPeerConnectionTimeOut  : Word;
                                     ClientUDP               : PObject;
                                     OnConnectionPeerTimeOut : TOnConnectionPeerTimeOut;
                                     PeersConnected          : PPeersConnected);
Begin
 Inherited Create(False);
 vBufferID                := BufferID;
 FTerminateEvent          := TEvent.Create(Nil, True, False, 'VideoEvent');
 Priority                 := tpLowest;
 PeerConnectionOK         := vPeerConnectionOK;
 PeerConnectionTimeOut    := vPeerConnectionTimeOut;
 vClientUDP               := ClientUDP;
 vOnConnectionPeerTimeOut := OnConnectionPeerTimeOut;
 vPeersConnected          := PeersConnected;
End;

Constructor TProcessDataThread.Create(ClientUDP   : TIdUDPClient);
Begin
 Inherited Create(False);
 vMilisExec       := 3;
 FTerminateEvent  := TEvent.Create(Nil, True, False, 'VideoEvent');
 vClientUDP       := ClientUDP;
 Priority         := tpLowest;
End;

Procedure TThreadConnection.Kill;
Begin
 vKill := True;
 If FTerminateEvent <> Nil Then
  FTerminateEvent.SetEvent;
// Terminate;
End;

Procedure TProcessDataThread.Kill;
Begin
 vKill := True;
 If FTerminateEvent <> Nil Then
  FTerminateEvent.SetEvent;
 Terminate;
End;

Procedure TThreadConnection.Execute;
Var
 vNow           : TDateTime;
 vTempBufferID,
 Host,
 LocalHost      : String;
 Port           : Integer;
 vNotEnter,
 vResult,
 vBreak         : Boolean;
 vPeerConnected : TPeerConnected;
Begin
 PeerConnectionOK^ := False;
 Try
  vTempBufferID   := Copy(vBufferID, Pos(TDelimiter, vBufferID) + Length(TDelimiter), Length(vBufferID));
  Host            := Copy(vTempBufferID, 1, Pos('|', vTempBufferID) -1);
  Delete(vTempBufferID, 1, Pos('|', vTempBufferID));
  LocalHost  := Copy(vTempBufferID, 1, Pos(':', vTempBufferID) -1);
  Delete(vTempBufferID, 1, Pos(':', vTempBufferID));
  Port       := StrToInt(Copy(vTempBufferID, 1, Pos('!', vTempBufferID) -1));
  Delete(vTempBufferID, 1, Length(vTempBufferID));
  vBreak    := False;
  vResult   := False;
  vNotEnter := True;
  vNow      := Now;
  While (Not Terminated)         And
        (Not(vKill))             And
        (Not(PeerConnectionOK^)) Do
   Begin
    If vNotEnter Then
     Begin
      vNotEnter := False;
      If (vClientUDP <> Nil)  Then
       Begin
        If (vClientUDP^ <> Nil) Then
         Begin
          vPeersConnected^.GetPeerInfo(Host, Port, vPeerConnected);
          If  (vPeerConnected <> Nil)          Then
           If (vPeerConnected.Connected)       And
              (vPeerConnected.TransactionOpen) Then
            Begin
             PeerConnectionOK^ := True;
             vResult := True;
             vBreak  := True;
            End
          Else If (MilliSecondsBetween(Now, vNow) > PeerConnectionTimeOut) Then
           Begin
            If PeerConnectionOK^ Then
             Exit;
            vPeersConnected^.GetPeerInfo(Host, Port, vPeerConnected);
            If vPeerConnected <> Nil Then
             Begin
              If Not((vPeerConnected.Connected)        And
                     (vPeerConnected.TransactionOpen)) Then
               Begin
                vPeerConnected.TransactionOpen := False;
                vPeerConnected.Connected       := False;
                If Assigned(vOnConnectionPeerTimeOut) Then
//                 Synchronize(Procedure
                 Begin
                  vOnConnectionPeerTimeOut  (Host, LocalHost, Port);
                 End; //);
               End
              Else
               Begin
                PeerConnectionOK^ := True;
                vResult := True;
               End;
             End;
            vBreak := True;
           End;
         End
        Else
         vBreak := True;
       End
      Else
       Break;
     vNotEnter := True;
    End;
    If (vResult) Or
       (vBreak) Then
     Break
    Else
     Begin
      If (vClientUDP <> Nil) Then
      If (vClientUDP^ <> Nil) Then
       If TUDPClient(vClientUDP^).FTerminateEvent <> Nil Then
        TUDPClient(vClientUDP^).FTerminateEvent.WaitFor(10);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
     End;
   End;
 Except
 End;
End;

Procedure TProcessDataThread.Execute;
Var
 vExec     : TDateTime;
 vNotEnter : Boolean;
Begin
 vExec     := Now;
 vNotEnter := False;
 While (Not Terminated) And
       (Not(vKill))     Do
  Begin
   If Not (vNotEnter) Then
    Begin
     vNotEnter := True;
     If (MilliSecondsBetween(Now, vExec) > vMilisExec) Then
      Begin
       vExec := Now;
       If Assigned(vExecFunction) Then
        vExecFunction;
      End;
     {$IFDEF MSWINDOWS}
     {$IFNDEF FMX}Application.Processmessages;
           {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
     {$ENDIF}
     vNotEnter := False;
    End;
   FTerminateEvent.WaitFor(TReceiveTimeThread);
  End;
End;

Procedure TUDPClient.Execute;
Var
 A                   : Integer;
 vTempString,
 vTransactionData,
 vError,
 vSendData,
 vPeerReturn,
 vGetData            : String;
 vLocalPortSend,
 vPortReturn         : Word;
 vErrorConnect,
 vNotEnter           : Boolean;
 AItem               : TPeerConnected;
 vLastPing,
 vLastSend           : TDateTime;
 DataPack,
 DataPackRec         : TDataPack;
 vHostType           : THostType;
 DataValue           : TDataValue;
 DataTransactionType : TDataTransactionType;
 vSendDataB,
 vTempBuffer         : TIdBytes;
 Function GetPort    : Integer;
 Begin
  If vClientUDPReceive.DefaultPort = 0 Then
   Result := TInitPort
  Else
   Result := vClientUDPReceive.DefaultPort + 1;
 End;
 Procedure ConnectUDPServer(Value : Boolean);
 Begin
  Try
   If vClientUDPReceive = Nil Then
    Begin
     vClientUDPReceive                  := TIdUDPServer.Create(Nil);
     vClientUDPReceive.OnUDPRead        := UDPRead;
     vClientUDPReceive.BroadcastEnabled := True;
     vClientUDPReceive.BufferSize       := vBufferSize^;
     vClientUDPReceive.DefaultPort      := 0;
     PServer^                           := vClientUDPReceive;
    End;
   vClientUDPReceive.DefaultPort        := 0;
   vClientUDPReceive.Binding.IP         := LocalIP;
   vClientUDPReceive.Active             := True;
   vMyPort^                             := vClientUDPReceive.Binding.Port;
  Except
   vClientUDPReceive.Active             := False;
   vClientUDPReceive.Bindings.Clear;
   ConnectUDPServer(Value);
   Exit;
  End;
 End;
 Procedure CheckDefaultPort;
 Begin
  If vClientUDPReceive.DefaultPort <> vMyPort^ Then
   Begin
    vClientUDPReceive.Active      := False;
    vClientUDPReceive.DefaultPort := vMyPort^;
    vClientUDPReceive.Active      := True;
   End;
 End;
 Procedure ResolveData;
 Begin
  If vOnTranslate Then
   Exit
  Else
   vOnTranslate := True;
  Try
   If DataListReceive.Count > 0 Then
    Begin
     If vClientUDP <> Nil Then
      Begin
       UDPReceive(DataListReceive.Items[0].aValue);
       DataListReceive.DeleteItem(0);
      End;
    End;
  Except
  End;
  vOnTranslate := False;
 End;
 Procedure CopyData(Const Source : TDataValue; Var Dest : TDataValue);
 Begin
  Dest.InitBuffer          := Source.InitBuffer;
  Dest.FinalBuffer         := Source.FinalBuffer;
  Dest.PackID              := Source.PackID;
  Dest.MasterPackID        := Source.MasterPackID;
  Dest.LocalHost           := Source.LocalHost;
  Dest.HostSend            := Source.HostSend;
  Dest.HostDest            := Source.HostDest;
  Dest.MD5                 := Source.MD5;
  Dest.Value               := Source.Value;
  Dest.aValue              := Source.aValue;
  Dest.PortSend            := Source.PortSend;
  Dest.LocalPortSend       := Source.LocalPortSend;
  Dest.PortDest            := Source.PortDest;
  Dest.PackSize            := Source.PackSize;
  Dest.ValueSize           := Source.ValueSize;
  Dest.Tries               := Source.Tries;
  Dest.PackIndex           := Source.PackIndex;
  Dest.DataType            := Source.DataType;
  Dest.HostType            := Source.HostType;
  Dest.Compression         := Source.Compression;
  Dest.PartsTotal          := Source.PartsTotal;
  Dest.DataTransactionType := Source.DataTransactionType;
  Dest.SendType            := Source.SendType;
 End;
Begin
 Try
  vConnected^                     := False;
  vErrorConnect                   := False;
  vClientUDP.BufferSize           := vBufferSize^;
  vClientUDP.IPVersion            := vIPVersion;
  vClientUDP.Host                 := vHostIP;
  vClientUDP.Port                 := vHostPort;
//  vClientUDP.BoundIP              := LocalIP;
  vClientUDP.BroadcastEnabled     := True;
  vClientUDP.TransparentProxy     := vTransparentProxy;
  vClientUDP.ReceiveTimeout       := TReceiveTimeOutUDP;
  vClientUDP.Active               := True;
  vClientUDPSend.BufferSize       := vBufferSize^;
  vClientUDPSend.IPVersion        := vIPVersion;
  vClientUDPSend.Host             := vHostIP;
  vClientUDPSend.Port             := vHostPort;
//  vClientUDPSend.BoundIP          := LocalIP;
  vClientUDPSend.BroadcastEnabled := True;
  vClientUDPSend.TransparentProxy := vTransparentProxy;
  vClientUDPSend.ReceiveTimeout   := TReceiveTimeOutUDP;
  vClientUDPSend.Active           := True;
  If (vTCPPort > 0) Then
   Begin
    Try
     vTCPClient.Host                     := vHostIP;
     vTCPClient.Port                     := vTCPPort;
     vTCPClient.IPVersion                := vIPVersion;
//     vTCPClient.ConnectTimeout           := 5000;
//     vTCPClient.UseNagle                 := True;
     vTCPClient.ReadTimeout              := TReceiveTimeThread;
     vTCPClient.Connect;
     vTCPClient.Socket.SendBufferSize := vBufferSize^;
     vTCPClient.Socket.RecvBufferSize := vBufferSize^;
     vTCPClient.Socket.LargeStream    := False; // Read 4-byte Length Except
    Except
     On E : Exception Do
      Begin
       vErrorConnect                     := True;
       vError := E.Message;
      End;
    End;
   End;
  AItem                           := TPeerConnected.Create;
  AItem.RemoteIP                  := vHostIP;
  AItem.Port                      := vHostPort;
  vPeersConnected^.AddPeer(AItem);
  {$IFDEF MSWINDOWS}
  If (vTCPPort > 0) And (vSendType^ = stProxy) And (vTCPClient.Connected) Then
   AddPack(vHostIP, vHostPort, TConnecClient + Format(TLocalIPPackData, [LocalIP, vTCPClient.Socket.Binding.Port]) + vWelcome, False, ht_Server)
  Else
   AddPack(vHostIP, vHostPort, TConnecClient + Format(TLocalIPPackData, [LocalIP, vClientUDP.Binding.Port]) + vWelcome, False, ht_Server);
  {$ELSE}
   AddPack(vHostIP, vHostPort, TConnecClient + vWelcome, False, ht_Server);
  {$ENDIF}
 Except
  vClientUDP := Nil;
  vClientUDP.Free;
  Synchronize(Procedure
              Begin
               If Assigned(vOnError) Then
                vOnError(etConnection);
              End);
  Exit;
 End;
 vNotEnter  := False;
 vLastMD5   := '';
 vLastTimer := Now;
 vLastPing  := Now;
 DataValue  := Nil;
 If Not (vErrorConnect) Then
  Begin
   If (vClientUDP <> Nil) Then
    Begin
     While (Not Terminated) And
           (Not(vKill))     Do
      Begin
       If vInternalTimer^      Then
        Begin
         If Assigned(vOnTimer) Then
          Begin
           If (MilliSecondsBetween(Now, vLastTimer) >= vMilisTimer^) Then
            Begin
             vLastTimer := Now;
             If vSyncTimerInterface Then
              Synchronize(Procedure
                          Begin
                           vOnTimer;
                          End)
             Else
              vOnTimer;
            End;
          End;
        End;
       If Not vNotEnter Then
        Begin
         vNotEnter := True;
         Try
          Try
           If (ProcessDataThread = Nil) And (Not(OnPunch)) Then
            Begin
             If (vSendType^ = stProxy) Then
              Begin
               GetData;
               ResolveData;
              End;
            End;
           If (vListSend.Count > 0)   Then
            Begin
             If DataValue <> Nil Then
              FreeAndNil(DataValue);
             DataValue := TDataValue.Create;
             CopyData(vListSend.Items[0], DataValue);
             If (vListSend.Count > 0) Then
              vTries   := DataValue.Tries
             Else
              vTries   := -1;
             If (vRetryPacks <= vTries) And
                (vTries > 0)            Then
              Begin
               Synchronize(Procedure
                           Begin
                            If Assigned(vOnError) Then
                             vOnError(etTimeOut);
                           End);
               If (Pos(TConnecClient, DataValue.Value) > 0) And
                  (vSendType^ <> stProxy) Then
                Begin
                 Kill;
                 Continue;
                End;
               vListSend.DeleteItem(DataValue.MD5);
               vLastTimer := Now;
               vTries     := 0;
              End;
             If (vListSend.Count > 0) Then
              Begin
               If (vTries = 0)        Or
                  (MilliSecondsBetween(Now, vLastSend) > vTimeOut) Then
                Begin
                 If NegociateTransaction(vClientUDP,
                                         DataValue) Or
                   (DataValue.HostType = ht_Server) Then
                  Begin
                   If (DataValue.Value = '') And
                      (Length(DataValue.aValue) = 0) Then
                    Begin
                     vListSend.DeleteItem(DataValue.MD5);
                     vLastTimer := Now;
                     vTries     := 0;
                     Continue;
                    End;
                   vLastSend                      := Now;
                   DataTransactionType            := DataValue.DataTransactionType;
                   If (DataValue.HostSend = vMyOnLineIP^)            And
                      (MyIpClass(LocalIP, vIPVersion) =
                       MyIpClass(DataValue.LocalHost, vIPVersion)) Then
                    vPeerReturn                   := DataValue.LocalHost
                   Else
                    vPeerReturn                   := DataValue.HostSend;
                   vPortReturn                    := DataValue.PortSend;
                   vLocalPortSend                 := DataValue.LocalPortSend;
                   vHostType                      := DataValue.HostType;
                   vSendData                      := DataValue.Value;
                   vSendDataB                     := DataValue.aValue;
                   If vSendData <> '' Then
                    BuildDataPack(DataValue.HostSend,     DataValue.HostDest,
                                  DataValue.PortSend,     DataValue.PortDest,
                                  vSendData,              DataValue.DataType,
                                  DataPack,               DataValue.Compression,
                                  '',                     DataValue.PackSize,
                                  DataValue.MasterPackID, DataValue.PackIndex,
                                  DataValue.PartsTotal,   DataTransactionType,
                                  vSendType^)
                   Else
                    BuildDataPack(DataValue.HostSend,     DataValue.HostDest,
                                  DataValue.PortSend,     DataValue.PortDest,
                                  vSendDataB,             DataValue.DataType,
                                  DataPack,               DataValue.Compression,
                                  '',                     DataValue.PackSize,
                                  DataValue.PackIndex,    DataValue.ValueSize,
                                  DataValue.InitBuffer,   DataValue.FinalBuffer,
                                  DataValue.MasterPackID, DataValue.PartsTotal,
                                  DataTransactionType,    vSendType^);
                   If vHostType = ht_Server Then
                    Begin
                     DataPack.vHostSend := vMyOnLineIP^ + ':' + IntToStr(vMyOnlinePort^);
                     If (TSendType(DataPack.SendType) = stProxy) Then
                      DataPack.vHostDest := DataValue.HostSend + ':' + IntToStr(DataValue.PortSend)
                     Else
                      DataPack.vHostDest := vHostIP            + ':' + IntToStr(vHostPort);
                    End;
                   vTempString := StringReplace(StringReplace(DataPack.GetValue, TInitPack,  '', [rfReplaceAll]),
                                                              TFinalPack, '', [rfReplaceAll]);
                   If (DataPack.Compression) And (vTempString <> '') Then
                    vTempString := DecompressString(vTempString);
                   If vTempString <> '' Then
                    vSendData := vTempString
                   Else
                    vSendData := '';
                   DataPack.MD5      := DataValue.MD5;
                   DataPack.SendType := Integer(vSendType^);
                   If (vHostType = ht_Server) Or (TSendType(DataPack.SendType) = stProxy) Then
                    Begin
                     RawBytesPack(DataPack, vTransactionData);
                     If (vHostType <> ht_Server) And (TSendType(DataPack.SendType) = stProxy) Then
                      Begin
                       If TDataTypeDef(DataPack.DataType) <> dtRawString Then
                        StrToByte(vTransactionData, vTempBuffer, TSendType(DataPack.SendType))
                       Else
                        vTempBuffer := DataPack.aValue;
                       If ProcessDataThread = Nil Then
                        Begin
                         If (vTCPPort > 0) And (vTCPClient.Connected) Then
                          Begin
//                           vTCPClient.IOHandler.Write(vTempBuffer, Length(vTempBuffer));
                           vTCPClient.Socket.WriteDirect(vTempBuffer, Length(vTempBuffer));
                           vTCPClient.Socket.WriteBufferFlush;
                           vListSend.DeleteItem(DataPack.MD5);
                           If (ProcessDataThread = Nil) And (Not(OnPunch)) Then
                            GetData;
                           ResolveData;
                          End
                         Else
                          Begin
                           If vClientUDP.Active Then
                            vClientUDP.SendBuffer(vHostIP, vHostPort, vTempBuffer)
                           Else
                            vClientUDPReceive.SendBuffer(vHostIP, vHostPort, vTempBuffer);
                          End;
                        End
                       Else
                        Begin
                         If (vTCPPort > 0) And (vTCPClient.Connected) Then
                          Begin
//                           vTCPClient.IOHandler.Write(vTempBuffer, Length(vTempBuffer));
                           vTCPClient.Socket.WriteDirect(vTempBuffer, Length(vTempBuffer));
                           vTCPClient.Socket.WriteBufferFlush;
                           vListSend.DeleteItem(DataPack.MD5);
                           If (ProcessDataThread = Nil) And (Not(OnPunch)) Then
                            GetData;
                           ResolveData;
                          End
                         Else
                          Begin
                           If vClientUDPSend.Active Then
                            vClientUDPSend.SendBuffer(vHostIP, vHostPort, vTempBuffer)
                           Else
                            vClientUDPReceive.SendBuffer(vHostIP, vHostPort, vTempBuffer);
                          End;
                        End;
                      End
                     Else
                      Begin
                       If (TSendType(DataPack.SendType) = stProxy) And
                          (vTCPPort > 0)                           And
                          (vTCPClient.Connected)                   Then
                        Begin
                         StrToByte(vTransactionData, vTempBuffer, TSendType(DataPack.SendType));
                         vTCPClient.IOHandler.Write(vTempBuffer, Length(vTempBuffer));
//                         vTCPClient.Socket.WriteDirect(vTempBuffer, Length(vTempBuffer));
                         vTCPClient.Socket.WriteBufferFlush;
                         vListSend.DeleteItem(DataPack.MD5);
                        End
                       Else
                        Begin
                         If vClientUDP.Active Then
                          vClientUDP.SendBuffer(vHostIP, vHostPort,
                                                ToBytes(vTransactionData, vCodificao))
                         Else
                          vClientUDPReceive.SendBuffer(vHostIP, vHostPort,
                                                       ToBytes(vTransactionData, vCodificao));
                        End;
                      End;
                    End
                   Else
                    Begin
                     RawBytesPack(DataPack, vTransactionData);
                     If TDataTypeDef(DataPack.DataType) <> dtRawString Then
                      StrToByte(vTransactionData, vTempBuffer, TSendType(DataPack.SendType))
                     Else
                      vTempBuffer := DataPack.aValue;
                     If (vPeerReturn <> '') Then
                      Begin
                       If ProcessDataThread = Nil Then
                        Begin
                         If vClientUDP.Active Then
                          vClientUDP.SendBuffer(vPeerReturn, vPortReturn, vTempBuffer)
                         Else
                          vClientUDP.SendBuffer(vPeerReturn, vPortReturn, vTempBuffer);
                         If (vPortReturn <> vLocalPortSend) And (vLocalPortSend > 0) Then
                          Begin
                           If vClientUDP.Active Then
                            vClientUDP.SendBuffer(vPeerReturn, vLocalPortSend, vTempBuffer)
                           Else
                            vClientUDP.SendBuffer(vPeerReturn, vLocalPortSend, vTempBuffer);
                          End;
                        End
                       Else
                        Begin
                         If vClientUDPSend.Active Then
                          vClientUDPSend.SendBuffer(vPeerReturn, vPortReturn, vTempBuffer)
                         Else
                          vClientUDPSend.SendBuffer(vPeerReturn, vPortReturn, vTempBuffer);
                         If (vPortReturn <> vLocalPortSend) And (vLocalPortSend > 0) Then
                          Begin
                           If vClientUDPSend.Active Then
                            vClientUDPSend.SendBuffer(vPeerReturn, vLocalPortSend, vTempBuffer)
                           Else
                            vClientUDPSend.SendBuffer(vPeerReturn, vLocalPortSend, vTempBuffer);
                          End;
                        End;
                      End;
                     SetLength(vTempBuffer, 0);
                     If ProcessDataThread = Nil Then
                      Begin
                       {$IFDEF MSWINDOWS}
                       {$IFNDEF FMX}Application.Processmessages;
                             {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
                       {$ENDIF}
                      End;
                    End;
                   If (DataTransactionType = dtt_Pulse) And
                      (vTransactionData <> '') Then
                    Begin
                     StrToByte(vTransactionData, vTempBuffer, TSendType(DataPack.SendType));
                     For A := 0 to TPulseHits Do
                      Begin
                       If vHostType = ht_Server Then
                        Begin
                         If vClientUDP.Active Then
                          vClientUDP.SendBuffer(vHostIP, vHostPort,
                                                ToBytes(vTransactionData, vCodificao))
                         Else
                          vClientUDPReceive.SendBuffer(vHostIP, vHostPort,
                                                       ToBytes(vTransactionData, vCodificao));
                        End
                       Else
                        Begin
                         If vClientUDPSend.Active Then
                          vClientUDPSend.SendBuffer(vPeerReturn, vPortReturn, vTempBuffer)
                         Else
                          vClientUDPSend.SendBuffer(vPeerReturn, vPortReturn, vTempBuffer);
                        End;
                      End;
                     SetLength(vTempBuffer, 0);
                     If ProcessDataThread = Nil Then
                      Begin
                       {$IFDEF MSWINDOWS}
                       {$IFNDEF FMX}Application.Processmessages;
                             {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
                       {$ENDIF}
                      End;
                    End;
                   If ((Pos(TConnectPeer, vSendData) > 0)     Or
                       (DataTransactionType in [dtt_ASync,
                                                dtt_Pulse,
                                                dtt_direct])) Or
                      (vPeerReturn = '')                      Then
                    Begin
                     vListSend.DeleteItem(DataPack.MD5);
                     vLastTimer := Now;
                     vTries     := 0;
                     vNotEnter  := False;
                     If vRequestAlive Then
                      Begin
                       If (MilliSecondsBetween(Now, vLastPing) > TPingTimeOut) Then
                        Begin
                         vLastPing := Now;
                         SendPing;
                        End;
                      End;
                     FreeAndNil(DataValue);
                     vNotEnter  := False;
                     If (ProcessDataThread = Nil) And (Not(OnPunch)) Then
                      GetData;
                     If DataListReceive.Count > 0 Then
                      Begin
                       {$IFDEF MSWINDOWS}
                       {$IFNDEF FMX}Application.Processmessages;
                             {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
                       {$ENDIF}
                       If vClientUDP <> Nil Then
                        Begin
                         UDPReceive(DataListReceive.Items[0].aValue);
                         DataListReceive.DeleteItem(0);
                        End;
                       {$IFDEF MSWINDOWS}
                       {$IFNDEF FMX}Application.Processmessages;
                             {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
                       {$ENDIF}
                      End;
                     FTerminateEvent.WaitFor(TDelayThread);
                     Continue;
                    End;
                   If (Pos(TConnectPeer, vSendData) = 0) Then
                    Begin
                     {$IFDEF MSWINDOWS}
                     {$IFNDEF FMX}Application.Processmessages;
                           {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
                     {$ENDIF}
                    End;
                  End;
                 If (vListSend.Count > 0) Then
                  Begin
                   Try
                    System.TMonitor.Enter(vListSend);
                    TDataValue(vListSend[0]).Tries := vTries + 1;
                   Finally
                    System.TMonitor.PulseAll(vListSend);
                    System.TMonitor.Exit(vListSend);
                   End;
                  End;
                 FTerminateEvent.WaitFor(TDelayThread);
                End;
              End;
             FreeAndNil(DataValue);
            End;
          Except
           On E : Exception Do
            Begin
             vError := E.Message;
            End;
          End;
         Except
          Synchronize(Procedure
                      Begin
                       If Assigned(vOnError) Then
                        vOnError(etLostConnection);
                      End);
         End;
         If vRequestAlive Then
          Begin
           If (MilliSecondsBetween(Now, vLastPing) > TPingTimeOut) Then
            Begin
             vLastPing := Now;
             SendPing;
            End;
          End;
         vNotEnter := False;
  //       Continue;
        End;
       If (ProcessDataThread = Nil) And (Not(OnPunch)) Then
        GetData;
       ResolveData;
       FTerminateEvent.WaitFor(TDelayThread);
      End;
     vBufferCapture^ := ''; //.Value := '';
     If (vMyOnLineIP^ <> '') Then
      Begin
       BuildDataPack(vMyOnLineIP^, vHostIP,          vMyOnlinePort^,
                     vHostPort,    TDisconnecClient, dtString, DataPack);
       RawBytesPack(DataPack, vTransactionData);
       If Not(vSendType^ = stProxy) Then
        vClientUDP.SendBuffer(vHostIP, vHostPort,
                              ToBytes(vTransactionData, vCodificao));
      End;
     FTerminateEvent.WaitFor(TDelayThread);
     {$IFDEF MSWINDOWS}
     {$IFNDEF FMX}Application.Processmessages;
           {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
     {$ENDIF}
     If ProcessDataThread <> Nil Then
      ProcessDataThread.Kill;
     If ProcessDataThread <> Nil Then
      WaitForSingleObject(ProcessDataThread.Handle, TThreadWaitDead);
     vClientUDP.Active := False;
     vClientUDP.Free;
     vClientUDPSend.Active := False;
     vClientUDPSend.Free;
     If vClientUDPReceive <> Nil Then
      Begin
       vClientUDPReceive.Active := False;
       vClientUDPReceive.Free;
      End;
     Try
      If vTCPClient <> Nil Then
       Begin
        vTCPClient.Disconnect;
        FreeAndNil(vTCPClient);
       End;
     Except

     End;
    End;
  End;
 vConnected^ := False;
 vListSend.ClearList;
 vListSend.Free;
 DataListReceive.ClearList;
 DataListReceive.Free;
 ReceiveBuffers.ClearList;
 ReceiveBuffers.Free;
 FreeMem(PServer);
 PServer := Nil;
 If FTerminateEvent <> Nil Then
  FreeAndNil(FTerminateEvent);
 vCodificao        := Nil;
End;

Procedure TUDPServer.Execute;
Var
 vOnSend     : Boolean;
 PeerConnect : TPeerConnected;
Begin
 vOnSend    := False;
 While (Not Terminated) And
       (Not(vKill))     Do
  Begin
   If (DataListSend.Count > 0) And (Not (vOnSend)) Then
    Begin
     vOnSend := True;
     Try
      If DataListSend.Items[0].PackSendType = pstTCP Then
       Begin
        vPeersConnected^.GetPeerInfo(DataListSend.Items[0].Host,
                                     DataListSend.Items[0].Port,
                                     PeerConnect);
        If PeerConnect <> Nil Then
         Begin
          If PeerConnect.AContext <> Nil Then
           Begin
            PeerConnect.AContext.Connection.Socket.WriteDirect(DataListSend.Items[0].aValue,
                                                               Length(DataListSend.Items[0].aValue));
            PeerConnect.AContext.Connection.Socket.WriteBufferFlush;
           End;
         End;
       End
      Else
       vServer^.SendBuffer(DataListSend.Items[0].Host,
                           DataListSend.Items[0].Port,
                           vServer^.IPVersion,
                           DataListSend.Items[0].aValue);
{
               SendBuffer(DataListSend.Items[0].Host,
                          DataListSend.Items[0].Port,
                          vServer^.IPVersion,
                          DataListSend.Items[0].aValue);
}
     Finally
      DataListSend.DeleteItem(0);
      vOnSend := False;
     End;
    End;
   FTerminateEvent.WaitFor(2);
   {$IFDEF MSWINDOWS}
   {$IFNDEF FMX}Application.Processmessages;
         {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
   {$ENDIF}
  End;
 DataListSend.ClearList;
 DataListSend.Free;
 If FTerminateEvent <> Nil Then
  FreeAndNil(FTerminateEvent);
End;

Procedure TUDPClient.UDPReceive(Value : TIdBytes);
Var
 DataPack      : TDataPack;
 ReceiveBuffer : TReceiveBuffer;
 PeerConnected : TPeerConnected;
 vAtualStream,
 vHolePunch,
 StrMD5,
 StrTemp,
 vPeerReturn,
 vReturnValue  : String;
 vPosInit,
 vPortReturn   : Integer;
 vAtualStreamL2,
 vAtualStreamL : TIdBytes;
 Procedure SendPunchOK(Client    : TIdUDPClient; Value : String);
 Var
  vBufferSend,
  LocalHost,
  Host       : String;
  A, I, Port : Integer;
  IcmpClient : ^TIdUDPClient;
  vTempSendType : TSendType;
 Begin
  If vOnPunch Then
   Exit
  Else
   vOnPunch := True;
  Value      := StringReplace(Value, TPunchString, '', [rfReplaceAll]);
  Host       := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost  := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port       := StrToInt(Value);
{
  If (vMyOnLineIP^ <> Host) Or
     ((LocalHost = '') Or (LocalHost = '0.0.0.0')) Then
   vPeerReturn := Host
  Else
   vPeerReturn := LocalHost;
}
  If ((Host = vMyOnLineIP^)               And
      (MyIpClass(LocalIP,   vIPVersion)   =
       MyIpClass(LocalHost, vIPVersion))) And
     ((LocalHost <> '') And
     (LocalHost  <> '0.0.0.0'))           Then
   vPeerReturn                 := LocalHost
  Else
   vPeerReturn                 := Host;
  vPortReturn  := Port;
  Try
   vBufferSend   := Format('%s%s', [TPunchOKString, vMyOnLineIP^ + '|' + LocalIP + ':' + IntToStr(vMyOnlinePort^)]);
   vTempSendType := vSendType^;
   If vTempSendType = stNAT Then
    Begin
     For I := 0 To MaxPunchs - 1 Do
      Begin
       Try
//        If vTempSendType = stNAT Then
         vClientUDP.SendBuffer(vPeerReturn, vPortReturn, tIdBytes(CompressionDecoding.GetBytes(vBufferSend)));
//        Else
//         AddPack(vPeerReturn, vPortReturn, tIdBytes(CompressionDecoding.GetBytes(vBufferSend)), False, ht_Client, dtString, -1, dtt_aSync);
        FTerminateEvent.WaitFor(TTimePunch);
       Except
       End;
      End;
    End
   Else
    AddPack(vPeerReturn, vPortReturn, tIdBytes(CompressionDecoding.GetBytes(vBufferSend)),
            False, ht_Client, dtString, -1); //, dtt_aSync);
  Finally
//   vOnPunch := False;
  End;
 End;
 Function GetPeerWelcome(Value : String) : Boolean;
 Var
  LocalHost,
  Host          : String;
  LocalPort,
  Port          : Integer;
  PeerConnected : TPeerConnected;
 Begin
  Host          := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost     := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port          := StrToInt(Copy(Value, 1, Pos('!', Value) -1));
  Delete(Value, 1, Pos('!', Value));
  LocalPort     := StrToInt(Value);
  GetPeer(PeerConnected, Host, Port);
  Result := PeerConnected <> Nil;
  If Result Then
   Result := PeerConnected.WelcomeMessage = '';
  If Result Then
   PeerConnected.WelcomeMessage := Format('%s|%s:%d!%d', [Host, LocalHost, Port, LocalPort]);
 End;
 Procedure OpenTransaction(Value : String);
 Var
  vPeerReturn,
  LocalHost,
  Host          : String;
  I, Port,
  LocalPort     : Integer;
  PeerConnected : TPeerConnected;
 Begin
  If vOpenTrans^ Then
   Exit
  Else
   vOpenTrans^ := True;
  Value     := StringReplace(Value, TOpenTransaction, '', [rfReplaceAll]);
  Host      := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port      := StrToInt(Copy(Value, 1, Pos('!', Value) -1));
  Delete(Value, 1, Pos('!', Value));
  LocalPort := StrToInt(Value);
  GetPeer(PeerConnected, Host, Port);
  If PeerConnected = Nil Then
   Begin
    PeerConnected           := TPeerConnected.Create;
    PeerConnected.RemoteIP  := Host;
    PeerConnected.Port      := Port;
    PeerConnected.LocalIP   := LocalHost;
    PeerConnected.LocalPort := LocalPort;
{
    If (vMyOnLineIP^ <> Host) Or
       ((LocalHost = '') Or (LocalHost = '0.0.0.0')) Then
     vPeerReturn := Host
    Else
     vPeerReturn := LocalHost;
}
    If ((Host = vMyOnLineIP^)               And
        (MyIpClass(LocalIP,   vIPVersion)   =
         MyIpClass(LocalHost, vIPVersion))) And
       ((LocalHost <> '') And
       (LocalHost  <> '0.0.0.0'))           Then
     vPeerReturn                 := LocalHost
    Else
     vPeerReturn                 := Host;
    If vPeersConnected^.AddPeer(PeerConnected) Then
     AddPack(Host, Port, LocalPort, TWelcomeMessage + Format('%s|%s:%d!%d', [vMyOnLineIP^, LocalIP, vMyOnlinePort^, vMyPort^]));
    FTerminateEvent.WaitFor(TReceiveTimeThread);
   End;
//  vOpenTrans := False;
 End;
 Procedure PeerConnect(Value : String);
 Var
  LocalHost,
  Host          : String;
  Port          : Integer;
  PeerConnected : TPeerConnected;
 Begin
  Value         := StringReplace(Value, TPeerConnect, '', [rfReplaceAll]);
  Host          := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost     := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port          := StrToInt(Value);
//  If Not TUDPSuperClient(vUDPSuperClient).vPeerConnectionOK Then
//   Begin
    TUDPSuperClient(vUDPSuperClient).vPeerConnectionOK := True;
    vPeersConnected^.GetPeerInfo(Host, Port, PeerConnected);
    If PeerConnected = Nil Then
     Begin
      PeerConnected           := TPeerConnected.Create;
      PeerConnected.RemoteIP  := Host;
      PeerConnected.Port      := Port;
      PeerConnected.LocalIP   := LocalHost;
      PeerConnected.TransactionOpen := True;
      PeerConnected.Connected       := True;
      vPeersConnected^.AddPeer(PeerConnected);
     End
    Else
     Begin
      If (PeerConnected.Connected) Then
       Exit;
      PeerConnected.TransactionOpen := True;
      PeerConnected.Connected       := True;
      If vUDPSuperClient <> Nil Then
       Begin
  {
        If (TUDPSuperClient(vUDPSuperClient).ConnectPeerThread <> Nil) Then
         Begin
          Try
           TUDPSuperClient(vUDPSuperClient).ConnectPeerThread.Kill;
          Except
          End;
          WaitForSingleObject(TUDPSuperClient(vUDPSuperClient).ConnectPeerThread.Handle, 100);
          FreeAndNil(TUDPSuperClient(vUDPSuperClient).ConnectPeerThread);
         End;
  }
       End;
     End;
    {$IFDEF MSWINDOWS}
    {$IFNDEF FMX}Application.Processmessages;
          {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
    {$ENDIF}
    //XyberX
    //Ap�s negociar a Conex�o eu ligo a Thread de Recebimento
    Synchronize(Procedure
                Begin
                 If Assigned(vOnPeerConnected) then
                  vOnPeerConnected(PeerConnected);
                End);
{
    If ProcessDataThread = Nil Then
     Begin
      ProcessDataThread := TProcessDataThread.Create(vClientUDP);
      ProcessDataThread.ExecFunction := GetData;
      ProcessDataThread.Resume;
     End;
}
//   End;
 End;
 Procedure UpdatePunch(Client    : TIdUDPClient; Value : String);
 Var
  vBufferSend,
  LocalHost,
  Host          : String;
  A, I, Port    : Integer;
  PeerConnected : TPeerConnected;
  IcmpClient    : ^TIdUDPClient;
  vTempSendType : TSendType;
 Begin
  Value     := StringReplace(Value, TPunchOKString, '', [rfReplaceAll]);
  Host      := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port      := StrToInt(Value);
//  If Not TUDPSuperClient(vUDPSuperClient).vPeerConnectionOK Then
//   Begin
    GetPeer(PeerConnected, Host, Port);
    If PeerConnected = Nil Then
     Begin
      PeerConnected                 := TPeerConnected.Create;
      PeerConnected.RemoteIP        := Host;
      PeerConnected.LocalIP         := LocalHost;
      PeerConnected.Port            := Port;
      PeerConnected.TransactionOpen := True;
//      PeerConnected.Connected       := False;
      vPeersConnected^.AddPeer(PeerConnected);
     End;
    If PeerConnected.Connected Then
     Exit
    Else
     Begin
      If (PeerConnected.Connected)       Or
         (PeerConnected.TransactionOpen) Then
       Exit;
      If Not (PeerConnected.SendPeerConnect) Then
       Begin
        PeerConnected.SendPeerConnect    := True;
        If Not (PeerConnected.TransactionOpen) Then
         PeerConnected.TransactionOpen    := True;
        PeerConnected.RetriesTransaction := 0;
        If ((Host = vMyOnLineIP^)               And
            (MyIpClass(LocalIP,   vIPVersion)   =
             MyIpClass(LocalHost, vIPVersion))) And
           ((LocalHost <> '') And
           (LocalHost  <> '0.0.0.0'))           Then
         vPeerReturn                 := LocalHost
        Else
         vPeerReturn                 := Host;
        vPortReturn  := Port;
        Try
         vBufferSend                  := Format('%s%s', [TPeerConnect, vMyOnLineIP^ + '|' + LocalIP + ':' + IntToStr(vMyOnlinePort^)]);
  //       IcmpClient                   := @Client;
  //       IcmpClient^.Host             := vHostIP;
  //       IcmpClient^.Port             := vHostPort;
  //       IcmpClient^.BroadcastEnabled := True;
         vTempSendType := vSendType^;
         If vTempSendType = stNAT Then
          Begin
           For I := 0 To MaxPunchs - 1 Do
            Begin
             Try
//              If vTempSendType = stNAT Then
               Client.SendBuffer(vPeerReturn, vPortReturn, tIdBytes(CompressionDecoding.GetBytes(vBufferSend)));
//              Else
 //              AddPack(vPeerReturn, vPortReturn, tIdBytes(CompressionDecoding.GetBytes(vBufferSend)), False, ht_Client, dtString, -1, dtt_Async);
              FTerminateEvent.WaitFor(TTimePunch);
             Except
             End;
            End;
          End
         Else
          AddPack(vPeerReturn, vPortReturn, tIdBytes(CompressionDecoding.GetBytes(vBufferSend)), False, ht_Client, dtString, -1);
        Finally
        End;
       End;
     End;
//   End;
 End;
Begin
 //XyberX
 Try
  vHolePunch   := CompressionDecoding.GetString(TBytes(Value));
  If vSendType^ = stProxy Then
   If Pos(TFinalPack, vHolePunch) = 0 Then
    Exit;
  DataPack     := BytesDataPack(vHolePunch, vCodificao);
 Except
  vHolePunch   := CompressionDecoding.GetString(TBytes(Value));
  DataPack     := BytesDataPack(vHolePunch, vCodificao);
 End;
 vHolePunch   := DataPack.GetValue;
 If vHolePunch = '' Then
  vHolePunch   := CompressionDecoding.GetString(TBytes(Value));
{
 Try
  vHolePunch   := vGeralEncode.GetString(Value); //BytesToString(Value, vCodificao);
 Except
  vHolePunch   := CompressionDecoding.GetString(TBytes(Value));
 End;
}
 If Pos(TReplyString, vHolePunch) > 0 Then
  Begin
   vReturnValue := StringReplace(vReturnValue, TReplyString, '', [rfReplaceAll]);
   vListSend.DeleteItem(vReturnValue);
   vLastTimer := Now;
   vTries     := 0;
   Exit;
  End;
 If Pos(TPunchString, vHolePunch) > 0          Then
  Begin
   SendPunchOK(vClientUDP, vHolePunch);
   Exit;
  End
 Else If Pos(TPunchOKString, vHolePunch) > 0   Then
  Begin
   vNoPunch := False;
   UpdatePunch(vClientUDP, vHolePunch);
   Exit;
  End
 Else If Pos(TPeerConnect, vHolePunch) > 0     Then
  Begin
   If (vSendType^ = stProxy) And
      (vNoPunch)             Then
    UpdatePunch(vClientUDP, vHolePunch);
   PeerConnect(vHolePunch);
   Exit;
  End
 Else If Pos(TOpenTransaction, vHolePunch) > 0 Then
  Begin
   vNoPunch := True;
   OpenTransaction(vHolePunch);
   Exit;
  End
 Else If (vHolePunch = '') Then
  Exit;
 If (DataPack.MD5 = '') And
    (DataPack.PackMD5 = '') Then
  Begin
   vHolePunch   := vGeralEncode.GetString(Value); // CompressionDecoding.GetString(TBytes(Value));
   DataPack     := BytesDataPack(vHolePunch, vCodificao);
  End;
 StrMD5       := DataPack.MD5;
 If (StrMD5 = '') And (Length(Value) > 0) Then
  Begin
   vReturnValue    := BytesToString(Value, vCodificao);
   vBufferCapture^ := vReturnValue;
   Synchronize(Procedure
               Begin
                 If Assigned(vOnGetData)    Then
                  vOnGetData(vReturnValue);
               End);
   If ProcessDataThread = Nil Then
    Begin
     {$IFDEF MSWINDOWS}
     {$IFNDEF FMX}Application.Processmessages;
           {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
     {$ENDIF}
    End;
   Exit;
  End;
 If (StrMD5 = OldMD5) Then
  Exit;
 If StrToInt(DataPack.ValueSize) <> Length(DataPack.GetValue) Then
  Exit;
 OldMD5   := StrMD5;
 StrTemp  := DataPack.GetValue;
 If Assigned(vOnDataIn) Then
  Begin
   Synchronize(Procedure
               Begin
                vOnDataIn(DataPack.aValue);
               End);
   If ProcessDataThread = Nil Then
    Begin
     {$IFDEF MSWINDOWS}
     {$IFNDEF FMX}Application.Processmessages;
           {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
     {$ENDIF}
    End;
  End;
 If Not (TDataTypeDef(DataPack.DataType) in [dtBytes, dtBroadcastBytes, dtDataStream]) Then
  Begin
   If DataPack.Compression Then
    StrTemp     := DecompressString(StrTemp);
   If StrTemp <> BytesToString(Value, vCodificao) Then
    vReturnValue := StrTemp
   Else
    vReturnValue := DataPack.GetValue;
  End
 Else
  vReturnValue := StrTemp;
 If (TDataTypeDef(DataPack.DataType) in [dtBytes, dtBroadcastBytes, dtDataStream]) Then
  Begin
   PeerConnectionOK^ := True;
   If TDataTransactionType(DataPack.DataTransactionType) = dtt_Sync Then
    Begin
     If (DataPack.HostDest <> '0.0.0.0') And
        (DataPack.HostDest <> '')        Then
      Begin
       vPeerReturn := DataPack.HostDest;
       vPortReturn := DataPack.PortDest;
      End
     Else
      Begin
       vPeerReturn := DataPack.HostSend;
       vPortReturn := DataPack.PortSend;
      End;
     AddPack(vPeerReturn, vPortReturn, TReplyString + OldMD5, False);
    End;
   If TDataTypeDef(DataPack.DataType) <> dtDataStream Then
    Begin
     vPosInit                  := Pos(TInitBuffer, vReturnValue) + Length(TInitBuffer);
     ReceiveBuffer             := TReceiveBuffer.Create;
     ReceiveBuffer.vIdBuffer   := DataPack.PackMD5;
     ReceiveBuffer.vBufferSize := StrToInt(DataPack.PackSize);
     ReceiveBuffer.PackNo      := StrToInt(DataPack.PackIndex);
     ReceiveBuffer.PartsTotal  := StrToInt(DataPack.PartsTotal);
     ReceiveBuffer.vLastCheck  := Now;
     If (Pos(TInitBuffer, vReturnValue)       > 0) And
        (Pos(TFinalBuffer, vReturnValue)      > 0) Then //Bug Aqui, Falta um Caracter, est� indo o Dado de forma inapropriada, XyberX
      ReceiveBuffer.vBuffer := StringReplace(StringReplace(vReturnValue, TInitBuffer,  '', [rfReplaceAll]),
                                                                TFinalBuffer, '', [rfReplaceAll]) //Copy(vReturnValue, vPosInit, Pos(TFinalBuffer,  vReturnValue) - vPosInit + 1)
     Else If (Pos(TInitBuffer, vReturnValue)  > 0) Then
      ReceiveBuffer.vBuffer := Copy(vReturnValue, vPosInit,
                                         Length(vReturnValue))
     Else If (Pos(TFinalBuffer, vReturnValue) > 0) Then
      ReceiveBuffer.vBuffer := Copy(vReturnValue, 1, Pos(TFinalBuffer, vReturnValue) -1)
     Else
      ReceiveBuffer.vBuffer := Copy(vReturnValue, 1, Length(vReturnValue));
     ReceiveBuffers.AddItem(ReceiveBuffer);
     Try
      vAtualStream := ReceiveBuffers.GetValue(ReceiveBuffer.vIdBuffer);
     Except
     End;
     If vAtualStream <> '' Then
      Begin
       ReceiveBuffers.DeleteItem(ReceiveBuffer.vIdBuffer);
//       If DataPack.PackSize = Length(vAtualStream) Then
//        Begin
       If DataPack.Compression Then
        vAtualStream := DecompressString(vAtualStream);
       If vAtualStream <> '' Then
        Begin
         If Assigned(vOnGetLongString) Then
          Begin
           Synchronize(Procedure
                       Begin
                        vOnGetLongString(vAtualStream);
                        vAtualStream := '';
                       End);
           If ProcessDataThread = Nil Then
            Begin
             {$IFDEF MSWINDOWS}
             {$IFNDEF FMX}Application.Processmessages;
                   {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
             {$ENDIF}
            End;
          End;
        End;
//        End;
      End;
    End
   Else
    Begin
     If DataPack.InitBuffer Then
      Begin
       vDataReceived := 0;
       SetLength(vAtualStreamB, 0);
       SetLength(vAtualStreamB, StrToInt(DataPack.PackSize));
      End;
     If Length(DataPack.aValue) > 0 Then
      Begin
       If (StrToInt(DataPack.PackIndex) > -1) And (StrToInt(DataPack.PackIndex) <= StrToInt(DataPack.PackSize)) Then
        Begin
         Move(DataPack.aValue[0], vAtualStreamB[StrToInt(DataPack.PackIndex)], StrToInt(DataPack.ValueSize));
         vDataReceived := vDataReceived + Length(DataPack.aValue);
         If (vDataReceived = StrToInt(DataPack.PackSize)) Then
          Begin
           SetLength(vAtualStreamL, Length(vAtualStreamB));
           Move(vAtualStreamB[0], vAtualStreamL[0], Length(vAtualStreamB));
           SetLength(vAtualStreamB, 0);
           If DataPack.Compression Then
            DecompressStream(vAtualStreamL, vAtualStreamL2)
           Else
            Begin
             SetLength(vAtualStreamL2, Length(vAtualStreamL));
             Move(vAtualStreamL[0], vAtualStreamL2[0], Length(vAtualStreamL));
            End;
           If Length(vAtualStreamL2) > 0 Then
            Begin
             If Assigned(vOnBinaryIn) Then
              Begin
               Synchronize(Procedure
                           Begin
                            vOnBinaryIn(vAtualStreamL2);
                            SetLength(vAtualStreamL2, 0);
                           End);
               If ProcessDataThread = Nil Then
                Begin
                 {$IFDEF MSWINDOWS}
                 {$IFNDEF FMX}Application.Processmessages;
                       {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
                 {$ENDIF}
                End;
              End;
             SetLength(vAtualStreamL, 0);
            End;
          End;
        End;
      End;
    End;
  End
 Else
  Begin
   If Pos(TWelcomeMessage, vReturnValue) > 0  Then
    Begin
     vHolePunch := StringReplace(StrTemp, TWelcomeMessage, '', [rfReplaceAll]);
     PeerConnectionOK^ := True;
     If GetPeerWelcome(vHolePunch) Then
      Synchronize(Procedure
                  Begin
                   If Assigned(vOnPeerRemoteConnect) Then
                    vOnPeerRemoteConnect(vHolePunch);
                  End);
     Exit;
    End
   Else If (vLastMD5 = StrMD5) Or
      (StrTemp = TPunchString) Then
    Exit;
   vLastMD5 := StrMD5;
   If (Pos(TConnecClient, vReturnValue) > 0) Then
    Begin
     vConnected^ := True;
     If (vListSend.Count > 0) Then
      Begin
       vListSend.DeleteItem(0);
       vLastTimer := Now;
       vTries     := 0;
      End;
     Exit;
    End;
   If vReturnValue <> ''  Then
    Begin
     If (vListSend.Count > 0) Then
      Begin
       vListSend.DeleteItem(0);
       vLastTimer := Now;
       vTries     := 0;
      End;
     If  (Pos(TPeerInfo,   vReturnValue) > 0)  Or
         (Pos(TPeerNoData, vReturnValue) > 0)  Then
      Begin
       Synchronize(Procedure
                   Begin
                    If Assigned(vDataPeerInfo) Then
                     vDataPeerInfo(vReturnValue);
                   End);
      End;
     If (Pos(TGetPeerInfo, vReturnValue) = 0)  And
        (Pos(TPeerInfo, vReturnValue)    = 0)  And
        (Pos(TPeerNoData, vReturnValue)  = 0)  And
        ((Pos(TGetIp, vReturnValue)      > 0)  And
         (Pos(TGetPort, vReturnValue)    > 0)) Then
      Begin
       If (Pos(TConfirmPK, vReturnValue) > 0)  Then
        Begin
         vMyOnLineIP^ := Copy(vReturnValue,   Pos(TConfirmPK, vReturnValue) + Length(TConfirmPK),
                                              Pos(TGetIp, vReturnValue) - Length(TConfirmPK) - 1);
         Delete(vReturnValue, Pos(TConfirmPK, vReturnValue),
                              Pos(TGetIp, vReturnValue) + Length(TGetIp) - 1);
        End
       Else
        Begin
         vMyOnLineIP^ := Copy(vReturnValue,   1, Pos(TGetIp, vReturnValue) - 1);
         Delete(vReturnValue, 1, Pos(TGetIp, vReturnValue) + Length(TGetIp) - 1);
        End;
       If (vReturnValue <> '') Then
        If (Pos(TGetPort, vReturnValue) > 0) Then
         If Copy(vReturnValue, 1, Pos(TGetPort, vReturnValue) - 1) <> '' Then
          vMyOnlinePort^ := StrToInt(Copy(vReturnValue, 1, Pos(TGetPort, vReturnValue) - 1));
       If (vTCPPort > 0) And (vTCPClient.Connected) And (vSendType^ = stProxy) Then
        vMyPort^         := vTCPClient.Socket.Binding.Port
       Else
        vMyPort^          := vClientUDP.Binding.Port;
       vReturnValue      := '';
       Synchronize(Procedure
                   Begin
                    vConnected^ := True;
                    If Assigned(vOnConnected) Then
                     vOnConnected;
                   End);
      End;
     If (vConnected^) Or
        ((DataPack.HostDest = vHostIP) And (DataPack.PortDest = vHostPort)) Then
      Begin  //XyberX
       If DataPack.HostDest <> '0.0.0.0' Then
        vPeersConnected.GetPeerInfo(DataPack.HostDest, DataPack.PortDest, PeerConnected)
       Else
        vPeersConnected.GetPeerInfo(DataPack.HostSend, DataPack.PortSend, PeerConnected);
       If PeerConnected <> Nil Then
        Begin
         If vMyOnLineIP^ <> PeerConnected.RemoteIP Then
          vPeerReturn := PeerConnected.RemoteIP
         Else
          vPeerReturn := PeerConnected.LocalIP;
         If PeerConnected.Port > 0 Then
          vPortReturn  := PeerConnected.Port
         Else
          vPortReturn  := PeerConnected.TCPPort;
        End;
       If vReturnValue <> TReplyString Then
        Begin
         If (vReturnValue <> '') Then
          Begin
           If Not((Pos(TGetIp, vReturnValue) > 0)    And
                  (Pos(TGetPort, vReturnValue) > 0)) Then
            Begin
             If (DataPack.HostDest <> '0.0.0.0') And
                (DataPack.HostDest <> '')        Then
              Begin
               vPeerReturn := DataPack.HostDest;
               vPortReturn := DataPack.PortDest;
              End
             Else
              Begin
               vPeerReturn := DataPack.HostSend;
               vPortReturn := DataPack.PortSend;
              End;
             If Not(Pos(TSendPing, vReturnValue) > 0) Then
              AddPack(vPeerReturn, vPortReturn, TReplyString + OldMD5);
            End;
          End;
        End;
       If (vReturnValue <>   TReplyString)       And
          Not((Pos(TGetIp,   vReturnValue) > 0)  And
              (Pos(TGetPort, vReturnValue) > 0)) And
          (vReturnValue <> '')                   Then
        Begin
         vBufferCapture^ := vReturnValue;
         PeerConnectionOK^ := True;
         Synchronize(Procedure
                     Begin
                       If Assigned(vOnGetData) Then
                        vOnGetData(vReturnValue);
                     End);
         If ProcessDataThread = Nil Then
          Begin
           {$IFDEF MSWINDOWS}
           {$IFNDEF FMX}Application.Processmessages;
                 {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
           {$ENDIF}
          End;
        End;
      End;
    End;
  End;
End;

Procedure TUDPClient.UDPReceive(Value : String);
Var
 DataPack      : TDataPack;
 PeerConnected : TPeerConnected;
 vAtualStream,
 vHolePunch,
 StrMD5,
 StrTemp,
 vPeerReturn,
 vReturnValue : String;
 vPosInit,
 vPortReturn  : Integer;
 Procedure SendPunchOK(Client    : TIdUDPClient; Value : String);
 Var
  vBufferSend,
  LocalHost,
  Host       : String;
  I, Port    : Integer;
  IcmpClient : ^TIdUDPClient;
 Begin
  Value      := StringReplace(Value, TPunchString, '', [rfReplaceAll]);
  Host       := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost  := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port       := StrToInt(Value);
  If (vMyOnLineIP^ <> Host) Or
     ((LocalHost = '') Or (LocalHost = '0.0.0.0')) Then
   vPeerReturn := Host
  Else
   vPeerReturn := LocalHost;
  vPortReturn  := Port;
  Try
   vBufferSend       := Format('%s%s', [TPunchOKString, vMyOnLineIP^ + '|' + LocalIP + ':' + IntToStr(vMyOnlinePort^)]);
   IcmpClient        := @Client;
   IcmpClient^.Host  := vHostIP;
   IcmpClient^.Port  := vHostPort;
//    IcmpClient^.BroadcastEnabled := True;
   For I := 0 To MaxPunchs - 1 Do
    Begin
     Try
      IcmpClient^.SendBuffer(vPeerReturn, vPortReturn, ToBytes(vBufferSend, vCodificao));
//      IcmpClient^.Send(vPeerReturn, vPortReturn, vBufferSend, vCodificao);
      FTerminateEvent.WaitFor(TReceiveTimeThread);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
     Except
     End;
    End;
  Finally
  End;
 End;
 Function GetPeerWelcome(Value : String) : Boolean;
 Var
  LocalHost,
  Host          : String;
  LocalPort,
  Port          : Integer;
  PeerConnected : TPeerConnected;
 Begin
  Host          := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost     := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port          := StrToInt(Copy(Value, 1, Pos('!', Value) -1));
  Delete(Value, 1, Pos('!', Value));
  LocalPort     := StrToInt(Value);
  GetPeer(PeerConnected, Host, Port);
  Result := PeerConnected <> Nil;
  If Result Then
   Result := PeerConnected.WelcomeMessage = '';
  If Result Then
   PeerConnected.WelcomeMessage := Format('%s|%s:%d!%d', [Host, LocalHost, Port, LocalPort]);
 End;
 Procedure OpenTransaction(Value : String);
 Var
  LocalHost,
  Host          : String;
  Port          : Integer;
  PeerConnected : TPeerConnected;
 Begin
  Value     := StringReplace(Value, TOpenTransaction, '', [rfReplaceAll]);
  Host      := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port      := StrToInt(Value);
  GetPeer(PeerConnected, Host, Port);
  If PeerConnected = Nil Then
   Begin
    PeerConnected          := TPeerConnected.Create;
    PeerConnected.RemoteIP := Host;
    PeerConnected.Port     := Port;
    PeerConnected.LocalIP  := LocalHost;
    If vPeersConnected^.AddPeer(PeerConnected) Then
     AddPack(Host, Port, TWelcomeMessage + Format('%s|%s:%d', [vMyOnLineIP^, LocalIP, vMyOnlinePort^]));
   End;
 End;
 Procedure PeerConnect(Value : String);
 Var
  LocalHost,
  Host          : String;
  Port          : Integer;
  PeerConnected : TPeerConnected;
 Begin
  Value         := StringReplace(Value, TPeerConnect, '', [rfReplaceAll]);
  Host          := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost     := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port          := StrToInt(Value);
  GetPeer(PeerConnected, Host, Port);
  If PeerConnected = Nil Then
   Begin
    PeerConnected                 := TPeerConnected.Create;
    PeerConnected.RemoteIP        := Host;
    PeerConnected.Port            := Port;
    PeerConnected.LocalIP         := LocalHost;
    PeerConnected.Connected       := False;
    vPeersConnected^.AddPeer(PeerConnected);
   End;
  If PeerConnected.Connected Then
   Exit;
  PeerConnected.TransactionOpen := True;
  PeerConnected.Connected       := True;
  Synchronize(Procedure
              Begin
               If Assigned(vOnPeerConnected) then
                vOnPeerConnected(PeerConnected);
              End);
 End;
 Procedure UpdatePunch(Client    : TIdUDPClient; Value : String);
 Var
  vBufferSend,
  LocalHost,
  Host          : String;
  I, Port       : Integer;
  PeerConnected : TPeerConnected;
  IcmpClient    : ^TIdUDPClient;
 Begin
  Value     := StringReplace(Value, TPunchOKString, '', [rfReplaceAll]);
  Host      := Copy(Value, 1, Pos('|', Value) -1);
  Delete(Value, 1, Pos('|', Value));
  LocalHost := Copy(Value, 1, Pos(':', Value) -1);
  Delete(Value, 1, Pos(':', Value));
  Port      := StrToInt(Value);
  GetPeer(PeerConnected, Host, Port);
  If PeerConnected = Nil Then
   Begin
    PeerConnected                 := TPeerConnected.Create;
    PeerConnected.RemoteIP        := Host;
    PeerConnected.LocalIP         := LocalHost;
    PeerConnected.Port            := Port;
    PeerConnected.TransactionOpen := False;
    PeerConnected.Connected       := False;
    vPeersConnected^.AddPeer(PeerConnected);
   End;
  If PeerConnected.Connected Then
   Exit;
  PeerConnected.TransactionOpen    := True;
//  PeerConnected.Connected          := False;
  PeerConnected.RetriesTransaction := 0;
  If (vMyOnLineIP^ <> Host) Or
     ((LocalHost = '') Or (LocalHost = '0.0.0.0')) Then
   vPeerReturn := Host
  Else
   vPeerReturn := LocalHost;
  vPortReturn  := Port;
  Try
   vBufferSend                  := Format('%s%s', [TPeerConnect, vMyOnLineIP^ + '|' + LocalIP + ':' + IntToStr(vMyOnlinePort^)]);
   IcmpClient                   := @Client;
   IcmpClient^.Host             := vHostIP;
   IcmpClient^.Port             := vHostPort;
   IcmpClient^.BroadcastEnabled := True;
   For I := 0 To MaxPunchs - 1 Do
    Begin
     Try
      IcmpClient^.SendBuffer(vPeerReturn, vPortReturn, ToBytes(vBufferSend, vCodificao));
//      IcmpClient^.Send(vPeerReturn, vPortReturn, vBufferSend, vCodificao);
      FTerminateEvent.WaitFor(TReceiveTimeThread);
      {$IFDEF MSWINDOWS}
      {$IFNDEF FMX}Application.Processmessages;
            {$ELSE}FMX.Forms.TApplication.ProcessMessages;{$ENDIF}
      {$ENDIF}
     Except
     End;
    End;
  Finally
  End;
 End;
Begin
 //XyberX
 vHolePunch   := Value;
 If Pos(TPunchString, vHolePunch) > 0          Then
  Begin
   SendPunchOK(vClientUDP, vHolePunch);
   Exit;
  End
 Else If Pos(TPunchOKString, vHolePunch) > 0   Then
  Begin
   UpdatePunch(vClientUDP, vHolePunch);
   Exit;
  End
 Else If Pos(TPeerConnect, vHolePunch) > 0     Then
  Begin
   PeerConnect(vHolePunch);
   Exit;
  End
 Else If Pos(TOpenTransaction, vHolePunch) > 0 Then
  Begin
   OpenTransaction(vHolePunch);
   Exit;
  End
 Else If (vHolePunch = '') Then
  Exit;
 DataPack     := BytesDataPack(vHolePunch, vCodificao);
 StrMD5       := DataPack.MD5;
 If (StrMD5 = '') And (Value <> '') Then
  Begin
   vReturnValue    := Value;
   vBufferCapture^ := vReturnValue;
   Synchronize(Procedure
               Begin
                 If Assigned(vOnGetData)    Then
                  vOnGetData(vReturnValue);
               End);
   Exit;
  End;
 If (StrMD5 = OldMD5) Then
  Exit;
 OldMD5   := StrMD5;
 StrTemp  := DataPack.GetValue;
{
 StrTemp      := StringReplace(StringReplace(DataPack.Value, TInitBuffer,  '', [rfReplaceAll]),
                                                             TFinalBuffer, '', [rfReplaceAll]);
}
 If Not (TDataTypeDef(DataPack.DataType) in [dtBytes, dtBroadcastBytes, dtDataStream]) Then
  Begin
   If DataPack.Compression Then
    StrTemp     := DecompressString(StrTemp);
   If StrTemp <> Value Then
    vReturnValue := StrTemp
   Else
    vReturnValue := DataPack.GetValue;
  End
 Else
  vReturnValue := StrTemp;
 If Pos(TReplyString, vReturnValue) > 0 Then
  Begin
   vReturnValue := StringReplace(vReturnValue, TReplyString, '', [rfReplaceAll]);
   vListSend.DeleteItem(vReturnValue);
//   vListSend.DeleteItem(0);
   vLastTimer := Now;
   vTries     := 0;
   Exit;
  End;
 If (TDataTypeDef(DataPack.DataType) in [dtBytes, dtBroadcastBytes]) Then
  Begin
   If TDataTransactionType(DataPack.DataTransactionType) = dtt_Sync Then
    Begin
     If (DataPack.HostDest <> '0.0.0.0') And
        (DataPack.HostDest <> '')        Then
      Begin
       vPeerReturn := DataPack.HostDest;
       vPortReturn := DataPack.PortDest;
      End
     Else
      Begin
       vPeerReturn := DataPack.HostSend;
       vPortReturn := DataPack.PortSend;
      End;
     AddPack(vPeerReturn, vPortReturn, TReplyString + OldMD5, False);
    End;
   vPosInit := Pos(TInitBuffer,   vReturnValue) + Length(TInitBuffer);
   If (Pos(TInitBuffer, vReturnValue)       > 0) And
      (Pos(TFinalBuffer, vReturnValue)      > 0) Then //Bug Aqui, Falta um Caracter, est� indo o Dado de forma inapropriada, XyberX
    vAtualStream := StringReplace(StringReplace(vReturnValue, TInitBuffer,  '', [rfReplaceAll]),
                                                              TFinalBuffer, '', [rfReplaceAll]) //Copy(vReturnValue, vPosInit, Pos(TFinalBuffer,  vReturnValue) - vPosInit + 1)
   Else If (Pos(TInitBuffer, vReturnValue)  > 0) Then
    vAtualStream := Copy(vReturnValue, vPosInit,
                                       Length(vReturnValue))
   Else If (Pos(TFinalBuffer, vReturnValue) > 0) Then
    Begin
     If vAtualStream <> '' Then
      vAtualStream := vAtualStream +   Copy(vReturnValue, 1, Pos(TFinalBuffer, vReturnValue) -1);
    End
   Else
    vAtualStream   := vAtualStream +   Copy(vReturnValue, 1, Length(vReturnValue));
   If (Pos(TFinalBuffer, vReturnValue) > 0) And
      (vAtualStream <> '')                  Then
    Begin
     If StrToInt(DataPack.PackSize) = Length(vAtualStream) Then
      Begin
       If DataPack.Compression Then
        vAtualStream := DecompressString(vAtualStream);
       If vAtualStream <> '' Then
        Begin
         If Assigned(vOnGetLongString) Then
          Begin
           Synchronize(Procedure
                       Begin
                        vOnGetLongString(vAtualStream);
                        vAtualStream := '';
                       End);
          End;
        End;
      End;
    End;
  End
 Else
  Begin
   If Pos(TWelcomeMessage, vReturnValue) > 0  Then
    Begin
     vHolePunch := StringReplace(StrTemp, TWelcomeMessage, '', [rfReplaceAll]);
     If GetPeerWelcome(vHolePunch) Then
      Synchronize(Procedure
                  Begin
                   If Assigned(vOnPeerRemoteConnect) Then
                    vOnPeerRemoteConnect(vHolePunch);
                  End);
     Exit;
    End
   Else If (vLastMD5 = StrMD5) Or
      (StrTemp = TPunchString) Then
    Exit;
   vLastMD5 := StrMD5;
   If (Pos(TConnecClient, vReturnValue) > 0) Then
    Begin
     vConnected^ := True;
     If (vListSend.Count > 0) Then
      Begin
       vListSend.DeleteItem(vLastMD5);
       vLastTimer := Now;
       vTries     := 0;
      End;
     Exit;
    End;
   If vReturnValue <> ''  Then
    Begin
     If (vListSend.Count > 0) Then
      Begin
       vListSend.DeleteItem(vLastMD5);
       vLastTimer := Now;
       vTries     := 0;
      End;
     If  (Pos(TPeerInfo,   vReturnValue) > 0)  Or
         (Pos(TPeerNoData, vReturnValue) > 0)  Then
      Begin
       Synchronize(Procedure
                   Begin
                    If Assigned(vDataPeerInfo) Then
                     vDataPeerInfo(vReturnValue);
                   End);
      End;
     If (Pos(TGetPeerInfo, vReturnValue) = 0)  And
        (Pos(TPeerInfo, vReturnValue)    = 0)  And
        (Pos(TPeerNoData, vReturnValue)  = 0)  And
        ((Pos(TGetIp, vReturnValue)      > 0)  And
         (Pos(TGetPort, vReturnValue)    > 0)) Then
      Begin
       If (Pos(TConfirmPK, vReturnValue) > 0)  Then
        Begin
         vMyOnLineIP^ := Copy(vReturnValue,   Pos(TConfirmPK, vReturnValue) + Length(TConfirmPK),
                                              Pos(TGetIp, vReturnValue) - Length(TConfirmPK) - 1);
         Delete(vReturnValue, Pos(TConfirmPK, vReturnValue),
                              Pos(TGetIp, vReturnValue) + Length(TGetIp) - 1);
        End
       Else
        Begin
         vMyOnLineIP^ := Copy(vReturnValue,   1, Pos(TGetIp, vReturnValue) - 1);
         Delete(vReturnValue, 1, Pos(TGetIp, vReturnValue) + Length(TGetIp) - 1);
        End;
       If (vReturnValue <> '') Then
        If (Pos(TGetPort, vReturnValue) > 0) Then
         If Copy(vReturnValue, 1, Pos(TGetPort, vReturnValue) - 1) <> '' Then
          vMyOnlinePort^ := StrToInt(Copy(vReturnValue, 1, Pos(TGetPort, vReturnValue) - 1));
       If (vTCPPort > 0) And (vTCPClient.Connected) And (vSendType^ = stProxy) Then
        vMyPort^         := vTCPClient.Socket.Binding.Port
       Else
        vMyPort^         := vClientUDP.Binding.Port;
       vReturnValue      := '';
       Synchronize(Procedure
                   Begin
                    vConnected^ := True;
                    If Assigned(vOnConnected) Then
                     vOnConnected;
                   End);
      End;
     If (vConnected^) Or
        ((DataPack.HostDest = vHostIP) And (DataPack.PortDest = vHostPort)) Then
      Begin  //XyberX
       If DataPack.HostDest <> '0.0.0.0' Then
        vPeersConnected.GetPeerInfo(DataPack.HostDest, DataPack.PortDest, PeerConnected)
       Else
        vPeersConnected.GetPeerInfo(DataPack.HostSend, DataPack.PortSend, PeerConnected);
       If PeerConnected <> Nil Then
        Begin
         If vMyOnLineIP^ <> PeerConnected.RemoteIP Then
          vPeerReturn := PeerConnected.RemoteIP
         Else
          vPeerReturn := PeerConnected.LocalIP;
         If PeerConnected.Port > 0 Then
          vPortReturn  := PeerConnected.Port
         Else
          vPortReturn  := PeerConnected.TCPPort;
        End;
       If vReturnValue <> TReplyString Then
        Begin
         If (vReturnValue <> '') Then
          Begin
           If Not((Pos(TGetIp, vReturnValue) > 0)    And
                  (Pos(TGetPort, vReturnValue) > 0)) Then
            Begin
             If (DataPack.HostDest <> '0.0.0.0') And
                (DataPack.HostDest <> '')        Then
              Begin
               vPeerReturn := DataPack.HostDest;
               vPortReturn := DataPack.PortDest;
              End
             Else
              Begin
               vPeerReturn := DataPack.HostSend;
               vPortReturn := DataPack.PortSend;
              End;
             If Not(Pos(TSendPing, vReturnValue) > 0) Then
              AddPack(vPeerReturn, vPortReturn, TReplyString + OldMD5);
            End;
          End;
        End;
       If (vReturnValue <>   TReplyString)       And
          Not((Pos(TGetIp,   vReturnValue) > 0)  And
              (Pos(TGetPort, vReturnValue) > 0)) And
          (vReturnValue <> '')                   Then
        Begin
         vBufferCapture^ := vReturnValue;
         Synchronize(Procedure
                     Begin
                       If Assigned(vOnGetData) Then
                        vOnGetData(vReturnValue);
                     End);
        End;
      End;
    End;
  End;
End;

Procedure TUDPClient.UDPRead(AThread     : TIdUDPListenerThread;
                             Const AData : TIdBytes;
                             ABinding    : TIdSocketHandle);
Begin
 UDPReceive(AData);
End;

Procedure TUDPClient.Kill;
Begin
 vKill := True;
 If FTerminateEvent <> Nil Then
  FTerminateEvent.SetEvent;
 If vTCPClient <> Nil Then
  Begin
   Try
    vTCPClient.CheckForGracefulDisconnect;
    If vTCPClient.Connected Then
     vTCPClient.Disconnect;
   Except
   End;
   FreeAndNil(vTCPClient);
  End;
 Terminate;
End;

Procedure TUDPServer.Kill;
Begin
 vKill := True;
 If FTerminateEvent <> Nil Then
  FTerminateEvent.SetEvent;
 Terminate;
End;

Function TUDPClient.AddPack(Peer                : String;
                            Port                : Word;
                            Value               : tIdBytes;
                            Compression         : Boolean              = False;
                            SendHost            : THostType            = ht_Client;
                            DataType            : TDataTypeDef         = dtString;
                            DataSize            : Integer              = -1;
                            DataTransactionType : TDataTransactionType = dtt_Sync;
                            PackIndex           : Integer              = 0;
                            ValueSize           : Integer              = 0;
                            InitBuffer          : Boolean              = False;
                            FinalBuffer         : Boolean              = False;
                            InitBufferID        : String               = '';
                            PackNum             : Integer              = 0;
                            PartsTotal          : Integer              = 0) : String;
Var
 DataValue     : TDataValue;
 vBufferID     : String;
 PeerConnected : TPeerConnected;
Begin
 Result := '';
 If (Peer <> '') And (Port > 0) Then
  Begin
   DataValue                             := TDataValue.Create;
   vBufferID                             := GenBufferID;
   DataValue.PackID                      := Copy(vBufferID, 1, Length(vBufferID));
   If InitBufferID = '' Then
    DataValue.MasterPackID               := DataValue.PackID
   Else
    DataValue.MasterPackID               := InitBufferID;
   DataValue.PackIndex                   := PackNum;
   DataValue.HostSend                    := Peer;
   DataValue.HostDest                    := vMyOnLineIP^;
   vPeersConnected^.GetPeerInfo(Peer, Port, PeerConnected);
   If PeerConnected <> Nil Then
    DataValue.LocalHost                  := PeerConnected.LocalIP;
   DataValue.PortSend                    := Port;
   DataValue.LocalPortSend               := DataValue.PortSend;
   DataValue.PortDest                    := vMyOnlinePort^;
   DataValue.aValue                      := Value;
   DataValue.DataType                    := DataType;
   DataValue.MD5                         := DataValue.PackID;
   DataValue.HostType                    := SendHost;
   If PackIndex = -1 Then
    DataValue.PackIndex                  := 0
   Else
    DataValue.PackIndex                  := PackIndex;
   DataValue.PackSize                    := DataSize;
   DataValue.InitBuffer                  := InitBuffer;
   DataValue.FinalBuffer                 := FinalBuffer;
   If ValueSize = 0 Then
    DataValue.ValueSize                  := Length(Value)
   Else
    DataValue.ValueSize                  := ValueSize;
   DataValue.Compression                 := Compression;
   DataValue.DataTransactionType         := DataTransactionType;
   If PartsTotal = 0 Then
    DataValue.PartsTotal := 1
   Else
    DataValue.PartsTotal := PartsTotal;
   DataValue.SendType    := vSendType^;
   vListSend.AddItem(DataValue);
   Result                                := DataValue.PackID;
  End;
End;

Procedure TUDPServer.AddPack(Peer         : String;
                             Port         : Word;
                             Value        : tIdBytes;
                             PackSendType : TPackSendType = pstUDP);
Var
 DataValue     : TDataValueSend;
Begin
 If (Peer <> '') And (Port > 0) Then
  Begin
   DataValue                             := TDataValueSend.Create;
   DataValue.Host                        := Peer;
   DataValue.Port                        := Port;
   DataValue.aValue                      := Value;
   DataValue.PackSendType                := PackSendType;
   DataListSend.AddItem(DataValue);
  End;
End;

Function TUDPClient.AddPack(Peer                : String;
                            Port,
                            LocalPort           : Word;
                            Value               : String) : String;
Var
 DataValue     : TDataValue;
 vBufferID     : String;
 PeerConnected : TPeerConnected;
Begin
 Result := '';
 Try
  If Self <> Nil Then
   Begin
    If (Peer <> '') And (Port > 0) Then           //Erro acontecendo aqui
     Begin
      DataValue                            := TDataValue.Create;
      vBufferID                            := GenBufferID;
      DataValue.PackID                     := Copy(vBufferID, 1, Length(vBufferID));
      DataValue.MasterPackID               := DataValue.PackID;
      DataValue.HostSend                   := Peer;
      DataValue.HostDest                   := vMyOnLineIP^;
      vPeersConnected^.GetPeerInfo(Peer, Port, PeerConnected);
      If PeerConnected <> Nil Then
       Begin
        DataValue.LocalHost                := PeerConnected.LocalIP;
        DataValue.LocalPortSend            := PeerConnected.LocalPort;
       End;
      DataValue.PortSend                    := Port;
      DataValue.LocalPortSend               := LocalPort;
      DataValue.PortDest                    := vMyOnlinePort^;
      DataValue.Value                       := Value;
      DataValue.DataType                    := dtString;
      DataValue.MD5                         := DataValue.PackID;
      DataValue.HostType                    := ht_Client;
      DataValue.PackSize                    := Length(Value);
      DataValue.PackIndex                   := 0;
      DataValue.ValueSize                   := Length(Value);
      DataValue.Compression                 := False;
      DataValue.DataTransactionType         := dtt_Sync;
      DataValue.SendType                    := vSendType^;
      If Pos(TReplyString, Value) > 0 Then
       Begin
        DataValue.Compression               := False;
        DataValue.DataTransactionType       := dtt_ASync;
       End;
      DataValue.PartsTotal := 1;
      vListSend.AddItem(DataValue);
      Result                                := DataValue.PackID;
     End;
   End;
 Except
 End;
End;

Function TUDPClient.AddPack(Peer                : String;
                            Port                : Word;
                            Value               : String;
                            Compression         : Boolean              = False;
                            SendHost            : THostType            = ht_Client;
                            DataType            : TDataTypeDef         = dtString;
                            DataSize            : Integer              = -1;
                            DataTransactionType : TDataTransactionType = dtt_Sync;
                            InitBufferID        : String               = '';
                            PackIndex           : Integer              = 0;
                            PartsTotal          : Integer              = 0) : String;
Var
 DataValue     : TDataValue;
 vBufferID     : String;
 PeerConnected : TPeerConnected;
Begin
 Result := '';
 Try
  If Self <> Nil Then
   Begin
    If (Peer <> '') And (Port > 0) Then           //Erro acontecendo aqui
     Begin
      DataValue                             := TDataValue.Create;
      vBufferID                             := GenBufferID;
      DataValue.PackID                      := Copy(vBufferID, 1, Length(vBufferID));
      If InitBufferID = '' Then
       DataValue.MasterPackID               := DataValue.PackID
      Else
       DataValue.MasterPackID               := InitBufferID;
      DataValue.HostSend                    := Peer;
      DataValue.HostDest                    := vMyOnLineIP^;
      vPeersConnected^.GetPeerInfo(Peer, Port, PeerConnected);
      If PeerConnected <> Nil Then
       DataValue.LocalHost                  := PeerConnected.LocalIP;
      DataValue.PortSend                    := Port;
      DataValue.PortDest                    := vMyOnlinePort^;
      DataValue.Value                       := Value;
      DataValue.DataType                    := DataType;
      DataValue.MD5                         := DataValue.PackID;
      DataValue.HostType                    := SendHost;
      DataValue.PackSize                    := DataSize;
      If PackIndex = -1 Then
       DataValue.PackIndex                  := 0
      Else
       DataValue.PackIndex                  := PackIndex;
      DataValue.ValueSize                   := Length(Value);
      DataValue.Compression                 := Compression;
      DataValue.DataTransactionType         := DataTransactionType;
      DataValue.SendType                    := vSendType^;
      If Pos(TReplyString, Value) > 0 Then
       Begin
        DataValue.Compression               := False;
        DataValue.DataTransactionType       := dtt_ASync;
       End;
      If PartsTotal = 0 Then
       DataValue.PartsTotal := 1
      Else
       DataValue.PartsTotal := PartsTotal;
      vListSend.AddItem(DataValue);
      Result                                := DataValue.PackID;
     End;
   End;
 Except
 End;
End;

Constructor TUDPClient.Create(aSelf               : TObject;
                              TransparentProxy    : TIdCustomTransparentProxy;
                              HostIP              : String;
                              HostPort,
                              TimeOut,
                              RetryPacks          : Word;
                              OnError             : TOnError;
                              OnGetData           : TOnGetData;
                              OnConnected         : TOnConnected;
                              OnTimer             : TOnTimer;
                              OnPeerConnected     : TOnPeerConnected;
                              OnPeerRemoteConnect : TOnPeerRemoteConnect;
                              OnGetLongString     : TOnGetLongString;
                              OnDataIn            : TOnDataIn;
                              OnBinaryIn          : TOnDataIn;
                              InternalTimer,
                              Connected           : PConnected;
                              BufferCapture       : PSafeString;
                              MyOnLineIP          : PMyOnLineIP;
                              MilisTimer,
                              MyPort,
                              MyOnlinePort,
                              BufferSize          : PMyPort;
                              PeersConnected      : PPeersConnected;
                              Welcome             : String;
                              Codificao           : IIdTextEncoding;
                              IPVersion           : TIdIPVersion;
                              DataPeerInfo        : TDataPeerInfo;
                              Server              : PUDPServer;
                              RequestAlive,
                              SyncTimerInterface  : Boolean;
                              SendType            : PSendType;
                              UDPSuperClient      : TObject;
                              vPeerConnectionOK   : PConnected;
                              TCPPort             : Word;
                              OpenTrans           : PConnected;
                              {$IFDEF MSWINDOWS}
                              vPriority           : TThreadPriority = tpLowest
                              {$ENDIF});
Begin
 Inherited Create(False);
 vSendType                   := SendType;
 vOnGet                      := False;
 vOnTranslate                := False;
 FTerminateEvent             := TEvent.Create(Nil, True, False, 'ListenThreadEvent');
 vListSend                   := TDataList.Create;
 {$IFDEF MSWINDOWS}
 Priority                    := vPriority;
 {$ENDIF}
 vKill                       := False;
 OnPunch                     := False;
 vNoPunch                    := True;
 vHostIP                     := HostIP;
 vHostPort                   := HostPort;
 vClientUDP                  := TIdUDPClient.Create(Nil);
 vClientUDPSend              := TIdUDPClient.Create(Nil);
 vTCPClient                  := TIdTCPClient.Create(Nil);
 vSelf                       := aSelf;
 vTimeOut                    := TimeOut;
 vRetryPacks                 := RetryPacks;
 vOnError                    := OnError;
 vOnGetData                  := OnGetData;
 vOnConnected                := OnConnected;
 vConnected                  := Connected;
 vPeersConnected             := PeersConnected;
 vMyOnLineIP                 := MyOnLineIP;
 vMyPort                     := MyPort;
 vMyOnlinePort               := MyOnlinePort;
 vBufferSize                 := BufferSize;
 vCodificao                  := Codificao;
 vBufferCapture              := BufferCapture;
 vWelcome                    := Welcome;
 vOnTimer                    := OnTimer;
 vOnPeerConnected            := OnPeerConnected;
 vOnPeerRemoteConnect        := OnPeerRemoteConnect;
 vOnGetLongString            := OnGetLongString;
 vOnDataIn                   := OnDataIn;
 vOnBinaryIn                 := OnBinaryIn;
 vInternalTimer              := InternalTimer;
 vMilisTimer                 := MilisTimer;
 vIPVersion                  := IPVersion;
 PServer                     := Server;
 vDataPeerInfo               := DataPeerInfo;
 vTransparentProxy           := TransparentProxy;
 vRequestAlive               := RequestAlive;
 vSyncTimerInterface         := SyncTimerInterface;
 ReceiveBuffers              := TReceiveBuffers.Create;
 ReceiveBuffers.vBufferSize  := vBufferSize^;
 DataListReceive             := TDataListReceive.Create;
 ProcessDataThread           := Nil;
 vOnPunch                    := False;
 vUDPSuperClient             := UDPSuperClient;
 PeerConnectionOK            := vPeerConnectionOK;
 vTCPPort                    := TCPPort;
 vOpenTrans                  := OpenTrans;
 vOpenTrans^                 := False;
End;

Constructor TUDPServer.Create(aSelf               : TObject;
                              Server              : PUDPServer;
                              TCPPort             : Word;
                              PeersConnected      : PPeersConnected;
                              {$IFDEF MSWINDOWS}
                              vPriority           : TThreadPriority = tpLowest
                              {$ENDIF});
Begin
 Inherited Create(False);
 FTerminateEvent             := TEvent.Create(Nil, True, False, 'ListenThreadEvent');
 DataListSend                := TDataListSend.Create;
 vServer                     := Server;
 vTCPPort                    := TCPPort;
 vPeersConnected             := PeersConnected;
 {$IFDEF MSWINDOWS}
 Priority                    := vPriority;
 {$ENDIF}
End;

Initialization
 CompressionEncoding         := TEncoding.ANSI;
 CompressionDecoding         := TEncoding.ANSI;
 vGeralEncode                := IndyTextEncoding_ASCII;
End.

