�
 TFORM1 0�	  TPF0TForm1Form1LeftETop� BorderIconsbiSystemMenu
biMinimize BorderStylebsSingleCaptionHTTPGet - demoClientHeight� ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PixelsPerInch`
TextHeight TProgressBarProgressBarLeft Top� Width�HeightAlignalBottomTabOrder   TPanelPanel1Left Top Width�Height_AlignalTop
BevelOuterbvNoneTabOrder TImageImageLeftTopWidth� Height9AutoSize	  TLabelLabel1Left� TopWidthHeightCaption;This sample demonstrates how to take string from CGI script  TLabelLabel3Left� Top WidthHeightCaption8for example, http://www.utilmind.com/cgi-bin/httpget.cgi  TBevelBevel1Left� TopWidthHeight]Shape
bsLeftLine  TButtonButton1Left.Top@WidthaHeightCaptionGet picture !TabOrder OnClickButton1Click  TButtonButton2LeftTop0Width� HeightCaptionGet String from CGI script !TabOrderOnClickButton2Click   	TGroupBox	GroupBox1Left Top_Width�HeightKAlignalClientCaptionGet file from web:TabOrder TLabelLabel2Left TopWidthHeightCaptionhttp://  TLabelLabel4LeftTop.Width3HeightCaptionOutput file:  TEditURLEditLeft@TopWidth� HeightTabOrder Textwww.941sf.com/wg/CqFir.rar  TEditFileNameEditLeft@Top*Width� HeightTabOrderText	CqFir.rar  TButtonButton3Left"TopWidthSHeightCaption
Get File !TabOrderOnClickButton3Click  	TCheckBoxUseCacheBoxLeft Top0WidthaHeightCaption	Use CacheTabOrderOnClickUseCacheBoxClick  TButtonButton4Left�TopWidthKHeightCaption	GetStreamTabOrderOnClickButton4Click   THTTPGetHTTPGetPictureAcceptTypes*/*AgentUtilMind HTTPGet
BinaryData	URLhttp://www.cqfd.com/ugmlogo.bmpUseCacheFileNametemp.bmp
WaitThread
OnProgressHTTPGetPictureProgress
OnDoneFileHTTPGetPictureDoneFileOnErrorHTTPGetPictureErrorLeftRTop  THTTPGetHTTPGetStringAcceptTypes*/*AgentUtilMind HTTPGet
BinaryDataURL+http://www.utilmind.com/cgi-bin/httpget.cgiUseCache
WaitThreadOnDoneStringHTTPGetStringDoneStringOnErrorHTTPGetPictureErrorLeft�Top2  THTTPGetHTTPGetFileAcceptTypes*/*AgentUtilMind HTTPGet
BinaryData	UseCache
WaitThread
OnProgressHTTPGetPictureProgress
OnDoneFileHTTPGetFileDoneFileOnDoneStreamHTTPGetFileDoneStreamOnErrorHTTPGetPictureErrorLeft|Topw   