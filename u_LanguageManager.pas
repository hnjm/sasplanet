unit u_LanguageManager;

interface

uses
  Windows,
  Classes,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_LanguageListStatic,
  i_LanguageManager,
  u_ConfigDataElementBase;

type
  TLanguageManager = class(TConfigDataElementBase, ILanguageManager)
  private
    FList: ILanguageListStatic;
    FDefaultLangCode: string;
    FNames : TStringList;
    procedure LoadLangs;
    procedure SetTranslateIgnore;
  protected
    procedure DoChangeNotify; override;
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetCurrentLanguageCode: string;
    procedure SetCurrentLanguageCode(ACode: string);

    function GetCurrentLanguageIndex: Integer;
    procedure SetCurrentLanguageIndex(AValue: Integer);

    function GetLanguageList: ILanguageListStatic;
    function GetLangNameByIndex(AIndex: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  Forms,
  Dialogs,
  Controls,
  ActnList,
  Graphics,
  GR32,
  EmbeddedWB,
  gnugettext,
  u_LanguagesEx,
  u_CommonFormAndFrameParents,
  u_LanguageListStatic;

{ TLanguageManager }

constructor TLanguageManager.Create;
begin
  inherited;
  FNames := TStringList.Create;
  FDefaultLangCode := 'en';
  SetTranslateIgnore;
  LoadLangs;
end;

destructor TLanguageManager.Destroy;
begin
  FreeAndNil(FNames);
  inherited;
end;

procedure TLanguageManager.DoChangeNotify;
var
  i: Integer;
begin
  // force reloading forms with new selection
  for i := 0 to application.ComponentCount - 1 do begin
    if application.Components[i] is TCommonFormParent then begin
      TCommonFormParent(application.Components[i]).RefreshTranslation;
    end else if application.Components[i] is TCommonFrameParent then begin
      TCommonFrameParent(application.Components[i]).RefreshTranslation;
    end;
  end;
  inherited;
end;

procedure TLanguageManager.DoReadConfig(AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    SetCurrentLanguageCode(AConfigData.ReadString('Lang', ''));
  end;
end;

procedure TLanguageManager.DoWriteConfig(AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteString('Lang', GetCurrentLanguageCode);
end;

function TLanguageManager.GetCurrentLanguageIndex: Integer;
begin
  if not FList.FindCode(GetCurrentLanguage, Result) then begin
    Result := 0;
  end;
end;

function TLanguageManager.GetCurrentLanguageCode: string;
var
  VIndex: Integer;
begin
  VIndex := GetCurrentLanguageIndex;
  if VIndex >= 0 then begin
    Result := FList.Code[VIndex];
  end else begin
    Result := '';
  end;
end;

function TLanguageManager.GetLangNameByIndex(AIndex: Integer): string;
begin
  Result := FNames[AIndex];
end;

function TLanguageManager.GetLanguageList: ILanguageListStatic;
begin
  Result := FList;
end;

procedure TLanguageManager.LoadLangs;
var
  VCodes : TStringList;
  VLanguagesEx: TLanguagesEx;

  procedure Add(AName, ACode : string);
  begin
    FNames.Add(AName);
    VCodes.Add(ACode);
  end;
var
  VinstalledLanguages: TStringList;
  i: Integer;
  id : LCID;
begin
  VCodes := TStringList.Create;
  try
    VLanguagesEx := TLanguagesEx.Create;
    try
      id := VLanguagesEx.GNUGetTextID[FDefaultLangCode];
      add(VLanguagesEx.EngNameFromLocaleID[id], FDefaultLangCode);

      VinstalledLanguages := TStringList.Create;
      try
        // get languages as a list of codes
        DefaultInstance.GetListOfLanguages('default', VinstalledLanguages);

        // add them into the list
        for i := 0 to VinstalledLanguages.Count - 1 do begin
          if (VinstalledLanguages[i] <> FDefaultLangCode) then begin
            id := VLanguagesEx.GNUGetTextID[VinstalledLanguages[i]];
            add(VLanguagesEx.EngNameFromLocaleID[id], VinstalledLanguages[i]);
          end;
        end;
      finally
        VinstalledLanguages.Free;
      end;
    finally
      VLanguagesEx.Free;
    end;
    FList := TLanguageListStatic.Create(VCodes);
  finally
    VCodes.Free;
  end;
end;

procedure TLanguageManager.SetCurrentLanguageIndex(AValue: Integer);
var
  VLastUsedCode: string;
  VCurrCode: string;
begin
  LockWrite;
  try
    VLastUsedCode := GetCurrentLanguage;
    if AValue >= 0 then begin
      UseLanguage(FList.Code[AValue]);
    end else begin
      UseLanguage(FDefaultLangCode);
    end;
    VCurrCode := GetCurrentLanguage;
    if VLastUsedCode <> VCurrCode then begin
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TLanguageManager.SetCurrentLanguageCode(ACode: string);
var
  VIndex: Integer;
begin
  if FList.FindCode(ACode, VIndex) then begin
    SetCurrentLanguageIndex(VIndex);
  end;
end;

procedure TLanguageManager.SetTranslateIgnore;
begin
  TP_GlobalIgnoreClass(TFont);
  TP_GlobalIgnoreClassProperty(TAction,'Category');
  TP_GlobalIgnoreClassProperty(TControl,'HelpKeyword');
  TP_GlobalIgnoreClassProperty(TWinControl,'ImeName');
  TP_GlobalIgnoreClassProperty(TEmbeddedWB,'StatusText');
  TP_GlobalIgnoreClassProperty(TEmbeddedWB,'UserAgent');
  TP_GlobalIgnoreClassProperty(TEmbeddedWB,'About');
  TP_GlobalIgnoreClassProperty(TOpenDialog,'DefaultExt');
  TP_GlobalIgnoreClassProperty(TCustomBitmap32,'ResamplerClassName');

end;

end.
