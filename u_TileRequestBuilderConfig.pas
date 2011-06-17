unit u_TileRequestBuilderConfig;

interface

uses
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_TileRequestBuilderConfig,
  u_ConfigDataElementBase;

type
  TTileRequestBuilderConfigStatic = class(TInterfacedObject, ITileRequestBuilderConfigStatic)
  private
    FUrlBase: string;
    FRequestHeader: string;
  protected
    function  GetUrlBase: string;
    function  GetRequestHeader: string;
  public
    constructor Create(
      AUrlBase: string;
      ARequestHeader: string
    );
  end;

  TTileRequestBuilderConfig = class(TConfigDataElementBase, ITileRequestBuilderConfig)
  private
    FUrlBase: string;
    FRequestHeader: string;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function  GetUrlBase: string;
    procedure SetUrlBase(AValue: string);

    function  GetRequestHeader: string;
    procedure SetRequestHeader(AValue: string);
  public
    constructor Create(ADefConfig: ITileRequestBuilderConfigStatic);
  end;

implementation

uses
  SysUtils;

{ TTileRequestBuilderConfig }

constructor TTileRequestBuilderConfig.Create(ADefConfig: ITileRequestBuilderConfigStatic);
begin
  inherited Create;
  FUrlBase := ADefConfig.UrlBase;
  FRequestHeader := ADefConfig.RequestHeader;
end;

procedure TTileRequestBuilderConfig.DoReadConfig(
  AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FUrlBase := AConfigData.ReadString('URLBase', FUrlBase);
    FRequestHeader := AConfigData.ReadString('RequestHead', FRequestHeader);
    FRequestHeader := StringReplace(FRequestHeader, '\r\n', #13#10, [rfIgnoreCase, rfReplaceAll]);
    SetChanged;
  end;
end;

procedure TTileRequestBuilderConfig.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteString('URLBase', FUrlBase);
  AConfigData.WriteString('RequestHead', StringReplace(FRequestHeader, #13#10, '\r\n', [rfIgnoreCase, rfReplaceAll]));
end;

function TTileRequestBuilderConfig.GetRequestHeader: string;
begin
  LockRead;
  try
    Result := FRequestHeader;
  finally
    UnlockRead;
  end;
end;

function TTileRequestBuilderConfig.GetUrlBase: string;
begin
  LockRead;
  try
    Result := FUrlBase;
  finally
    UnlockRead;
  end;
end;

procedure TTileRequestBuilderConfig.SetRequestHeader(AValue: string);
begin
  LockWrite;
  try
    if FRequestHeader <> AValue then begin
      FRequestHeader := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TTileRequestBuilderConfig.SetUrlBase(AValue: string);
begin
  LockWrite;
  try
    if FUrlBase <> AValue then begin
      FUrlBase := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

{ TTileRequestBuilderConfigStatic }

constructor TTileRequestBuilderConfigStatic.Create(AUrlBase,
  ARequestHeader: string);
begin
  FUrlBase := AUrlBase;
  FRequestHeader := ARequestHeader;
end;

function TTileRequestBuilderConfigStatic.GetRequestHeader: string;
begin
  Result := FRequestHeader;
end;

function TTileRequestBuilderConfigStatic.GetUrlBase: string;
begin
  Result := FUrlBase;
end;

end.
