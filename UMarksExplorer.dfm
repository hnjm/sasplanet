object FMarksExplorer: TFMarksExplorer
  Left = 561
  Top = 250
  BorderStyle = bsDialog
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1084#1077#1090#1082#1072#1084#1080
  ClientHeight = 420
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 360
    Width = 561
    Height = 9
    Shape = bsTopLine
  end
  object GroupBox1: TGroupBox
    Left = 216
    Top = 8
    Width = 273
    Height = 345
    Caption = ' '#1052#1077#1090#1082#1080' '
    TabOrder = 0
    object BtnGotoMark: TSpeedButton
      Left = 80
      Top = 16
      Width = 29
      Height = 29
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1086#1073#1098#1077#1082#1090#1091
      Glyph.Data = {
        96030000424D960300000000000036000000280000000F000000120000000100
        1800000000006003000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7778BEFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF6E6EB5FF00FFFF00FF77
        78BE3035DA3133BAFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF
        FF00FFFF00FF3638C02F31B16F70B7585DE1737AF54A4FE33032B8FF00FFFF00
        FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF5A5FD43439DA5D64DB96
        9EEF7B82E9787FF15259E5383BBCFF00FFFF00FFFF00FF000000FF00FFFF00FF
        FF00FFFF00FF484BD6474CF95D62F27177ED8B93EB868EE88E94F23539D13C3C
        B5FF00FFFF00FF000000FF00FFFF00FF87C3E372BFDC4646E02628F73C3FF347
        4BF2595EEF838AF04F58D92222B7FF00FFFF00FFFF00FF000000FF00FF87C3E3
        7AC2E087C3E34947EB0C0DFA2629F53235F34445F22F34D833239BC6705DFF00
        FFFF00FFFF00FF00000087C3E37FC9E576A7C1BF907D2F30F30000FF0404FD0F
        10FB2026FF121DE5382AA2D87B43D47453FF00FFFF00FF00000087C3E391B8D2
        A18181559ED65058F0413FE74D4FE45656DE6456CA796AC6695EBB744A82E77F
        38D07F75FF00FF00000087C3E383BEDFAF8F752E9DDD6597BAAC92786B9DB395
        978DE44E0CDD6324EE8F44E68442E1823FD87651EEAD94000000FF00FF63B4DD
        849A99B19A79ADA1837FA6A85FA5BDC0916DE15813D46426EB8B49E78946E484
        40DE7948EEAD94000000FF00FFEEAD945EA2BC66B1CA66B0CE60B0D3A2B7AEF7
        864CC77237A47B34EA7140E17D40E4843FDF7B49EEAD94000000FF00FFEEAD94
        B96442A3B2A9A1D2D3CED6C0FDC28DE99662EB9460EA8859E48157E16D43DF73
        30DD7B51EEAD94000000FF00FFFF00FFCF5E1ADE8C3AFFE8C1FFEAC1EFBC94F3
        AD7EBEB376E1A375EB946FDF956FDB6023C95C43FF00FF000000FF00FFFF00FF
        BE9077C16A1DF5C4A4F4E4C9F4CBAAF0B895F0B592EDAB8AEEAD94C0A774C840
        0FC39390FF00FF000000FF00FFFF00FFFF00FFCD6D55EB9A6DFAE8CBF8DBC1F6
        D2B8F4CDB3F4C9AFF0B69ADD6743C4857EFF00FFFF00FF000000FF00FFFF00FF
        FF00FFFF00FFCF8B82E6997DEFBDA0EFBDA0EFBDA0EDB79DDE826ECB9291FF00
        FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE6997DE6
        997DE6997DE6997DFF00FFFF00FFFF00FFFF00FFFF00FF000000}
      ParentShowHint = False
      ShowHint = True
      OnClick = BtnGotoMarkClick
    end
    object BtnOpMark: TSpeedButton
      Left = 112
      Top = 16
      Width = 29
      Height = 29
      Hint = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1086#1073#1083#1072#1089#1090#1100#1102' '#1074' '#1075#1088#1072#1085#1080#1094#1072#1093' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072
      Glyph.Data = {
        36060000424D3606000000000000360000002800000015000000180000000100
        1800000000000006000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8585852E2E2E5C5C5C8686
        86D9D9D9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8E8E8E2121212A2A2A2C2C2C4F4F
        4F727272ACACACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFC2C2C23838385A5A5A5A5A5A3B3B3B2020
        204D4D4D6363638C8C8CFF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFD0D0D09090907C7C7C7575756F6F6F7575755555
        55363636565656777777909090FF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFA0A0A0C4C4C4D3D3D38B8B8B6C6C6C8080809F9F
        9F8F8F8F5151514241426E6F6E908E90ABA7ABFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFF00FFA5A5A5B6B6B6DFDFDFF3F3F3F4F4F4BFBEBE8B8B8B8787
        87ABABABB5B6B57172713C3D3C4E6F4E77A577ACADACFF00FF00FF00FFFF00FF
        FF00FFFF00FFA4A4A4B2B2B2D8D8D7E3E2E2E7E7E7EBEBEBF2F2F2DDDEDEB0AF
        AE8F8F8FA2A2A2BBBCBB8C8A8C376C372883287A817AB5B5B500FF00FFFF00FF
        FF00FFA4A4A49F9F9FC9C9C8CACBCBC2C6C6BDC0C0BABABAB7B6B6C3C5C5D8DB
        DDCBCCCDA09F9F909191A5A6A58E968E4A554A565C56AAA9AA00FF00FFFF00FF
        DFDFDF9B9B9BBFBFBFBABEBFAFA8A5A3897CA17C6B9E7563A47F70B1978FA792
        8BC4C0BEE0E4E5BBBCBC8D8E8E8989898383837F807FFF00FF00FF00FFD8D9D9
        6C6C6CC0C1C1B8B9BAAB968DA36E56A86F4EAB7554A16A48B58C75D7C1B7BD9A
        8B9D7160C0AFA8F5F7F8D6D5D59C9C9C999999FF00FFFF00FF00DADBDB3F3E3F
        444544BFC0C1BAA59DBF998BA77158A065429A5C34915023B49076CFBDAFCCB8
        AAB28D7C9F725CC2ABA0FFFFFFDFDEDEFF00FFFF00FFFF00FF00ABACAC434141
        5C5F617F6C66BE9280A7705F99574199523AB78575C8A295D4B8B0D2BAB1CEB5
        ABC1A69DBAA092A27660BEABA2FF00FFFF00FFFF00FFFF00FF00C9C9C8727374
        817F7E976552A566519A643CA0693CA77545DACAAFE6E2C7DED3B4D8CDAED0BE
        9CD4BC98C3A999A8806B986C59FF00FFFF00FFFF00FFFF00FF00FF00FFCED2D3
        7B63589F5C44A5603A706673636B8A59638E636E8A758DB7677BAA768BB05E84
        9A787DC0C5A6AAC6B1A1B28B7DAF9C95FF00FFFF00FFFF00FF00FF00FFFF00FF
        D4C0B89D5A45BD80545C61975B41BDAE7E86A7849DC7B3D8C9BEE8D6C3EBADB3
        C56287A5CBAEAFC2AF9DB89686A98576FF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFC8A69CD2A7917A7E7093849FDFB88BD9C0A6E5D0B7F3E9D5FFF8F0DAE6
        BD5A72BBD4BCBBC6B2A0C09F8F956C5DFF00FFFF00FFFF00FF00FF00FFFF00FF
        EADFDAC19C8FCEA18182949BA09DD9F5DFC5DDD0C4DBC7B6E5DBCFF2E2E0C6CC
        AA627AB9CBAAA5B5957BC6A797936B5DFF00FFFF00FFFF00FF00FF00FFFF00FF
        EDE0DAB78773DFC0A28AA2AEA3A7E9FBF8F2EAE4DCE8DECEE8E0D3ECDAD2C5CB
        A45C77A4BA8E81945E35A87458A98476FF00FFFF00FFFF00FF00FF00FFFF00FF
        F1E8E5C39A86E6CDB096AEB5ABAFE2FFFAF2F6F1EDF8F2ECF4EFE7FAE7E6CCD4
        B2536CADC19990A6744E945431AC8F82FF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFCDAF9DD7B88E8EAEAF9CA6D8E9F5D5E6EFDBEAF5DFE8F2DBE8E8D5C7D5
        A65A74A9CBA8A1B17F5C9C6C53DDD2CDFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFF9F5F2DEC49E989DB77C96CC6E80D07D91D0758CD16E82D1778AC9697F
        B43C42ECC8A2A7A87751DFD2CCFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFEFCFAD7C0B5E1D6D1F7F5FCF7F4FCF6F6FFF5F3FCF0E8ECEBDF
        E1E1CBB7BB957BE1D1C8FF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFF00FFFCFAF5DECCB6DFCFB8F0E8D9F6F1E7F4EDE1EADDCCD8C0
        AAC8AE99EBE4E0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFF1EAE3F9F5F0FCF9F5FBF8F4F7F2EDF0E8
        E2F7F5F4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00}
      ParentShowHint = False
      ShowHint = True
      OnClick = BtnOpMarkClick
    end
    object BtnDelMark: TSpeedButton
      Left = 40
      Top = 16
      Width = 29
      Height = 29
      Hint = #1059#1076#1072#1083#1080#1090#1100
      Glyph.Data = {
        26040000424D2604000000000000360000002800000012000000120000000100
        180000000000F003000000000000000000000000000000000000FF00FFFF00FF
        E6E6E6DCDCDCD6D6D6D8D8D8D9D9D9D9D9D9D2D6D1D3D6DED0D5EAC5D1DDC2D1
        D3D4DAD5FF00FFFF00FFFF00FFFF00FF00008D8D8D8585858383838282828585
        8586868685858583838385848683967B4A469F1F0BB82517BD667E8A665FB020
        12BE402CCB877BDF0000848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFCECF5FF3827C45D62FB5D66FF484BD11904B7515FFF5C5DFF3131A3
        0000858585FEFEFEFFFFFFEBEBEBEDEDEDECECECEAEAEAE9E9E9F2EBE8D7F1E1
        828CDA0D00D1798AF94249F64847FF7885FF1107C58A8AE40000858585FFFFFF
        FDFDFDE1E1E1D6D6D6D4D4D4D5D5D5D7D7D7D2D6CAD1DFDEC1D8D4383BD30300
        BA4233FF4751FF0C00C73849C1FF00FF0000858585FDFDFDFFFFFFECECECEEEE
        EEEEEEEEEEEEEEEEEEEEFFE9FCE3EDDC9D8FDD0703C67F85FF8888FA6266F47C
        86FF0F09BA8E88E10000858585FFFFFFFFFFFFEEEEEEEEEEEEEDEDEDEEEEEEEE
        EEEEF2E8F4E4F1E32D1BD4ACA1FD8381FF0800C49DB4F87979FF949BFF2D29B8
        0000858585FCFCFCFFFFFFEFEFEFF2F2F2F1F1F1F0F0F0F0F0F0E7EFFCE1F0FF
        2619C3BBC6FFBFCDFE4C4AD91000C4BAD1FEB9CDF6271EC20000858585FFFFFF
        FEFEFEE4E4E4DBDBDBD9D9D9DBDBDBDEDEDEDCDFD0D6DED48386DB2C20B82B1E
        CDEDFDFF524C993B19C43B1EC8988DED0000858585FFFFFEFFFFFEF5F5F5F6F8
        F8F2F4F5F2F4F5F3F5F6F0F2F3F7F9FAF0F2F3F6F8F9F4F4F4FFFFFF848484D8
        D8D8FF00FFFF00FF0000858585FDFDFDFFFFFFF7F7F7F9FBFCF7F9FAF7F9FAF8
        FAFBF5F7F8F6F8F9F3F5F6F8F8F8F7F7F7FFFFFF858585D8D8D8FF00FFFF00FF
        0000858585FFFFFFFDFDFDEDEDEDDFE1E2DDDFE0DEE0E1DFE1E2E3E3E3DEDEDE
        E2E2E2DFDFDFE0E0E0E8E8E8838383DADADAFF00FFFF00FF0000858585FFFEFF
        FFFFFFFBFBFBFBFBFBFEFCFCFEFCFCFCFAF9FDFBFAFCFAF9FCFAF9DCDCDCD9D9
        D9DDDDDD868686E1E1E1FF00FFFF00FF0000858585FFFFFFFFFEFEFEFCFBFFFE
        FAFFFEFBFFFCF9FFFBF6FCF9F5FFFFFBDDDBDA959392858585949494848687EB
        EBEBFF00FFFF00FF0000858585FFFEFBF4EFECEEE9E6EEE6DFF1E9E2F4EBE2F5
        ECE3EEEAE5FFFFFA94918DFFFFFEFBF9F8EDEFF0969899FF00FFFF00FFFF00FF
        0000858585FFFFF9F5ECE3F3E8E0FAECE0FDEDE0FDEEDEFFEFDFF4EEE7FFFEF7
        898580FEFBF7F4F2F1BCBEBFFF00FFFF00FFFF00FFFF00FF0000828282FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFFFFFF939393F0F0F08686
        86FF00FFFF00FFFF00FFFF00FFFF00FF00008D8D8D8585858585858585858585
        858585858585858585858A8A8A8080808080809B9B9BFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF0000}
      Margin = 3
      ParentShowHint = False
      ShowHint = True
      OnClick = BtnDelMarkClick
    end
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 16
      Width = 29
      Height = 29
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C006000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFF2F2F2F3F3F3E3E3E3CEDBD9D5D3D3EADDDFDBCFCFDFDAD9
        E2DEDDE0D6D6E4CFD1D3D9D8D4DAD9D7DCDBD9DBDBD2D4D4DCDCDCFAF8F8FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F8E8E8E7F7F7F858C8987818293
        858B2D292F3E4B536F8A945D77836679887981807F85847C82818085848C8E8E
        7F7F7FE0DEDEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8A8A8AF5F5F5FFFF
        FFFDFEFCFFFEFFFBF3FA101C28001725337B8D2B799058A3BDD3DBDAF0F8F7FA
        FFFFFBFFFFF9FBFB8C8C8CDAD8D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        848484FFFFFFFFFFFFFEE5E1EBF2EDD0E7E93A506932739979D4FF7CD3FF1575
        996296B49BBFCFCEE5E7FFFDFDFFFEFF8A7F82D5DAD9FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF848484FFFFFFFFFFFFDBF0E8F1E4E2DFE8EC448C969EE7FF
        72D4FC5AD5FB6CD1F8076E955790AFB6C5D5F5F8FCF2FDFB848988D3D8D6FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848484FFFFFFFFFFFFD8E7E3D3DAD7D6
        D5D798B8C3187E907ADFFF6FDBFF60D2FB6ED3FF13719C4E90A9BFD6E6F6F0FB
        888385DAD9D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848484FFFFFFFFFF
        FFF0E9ECEBEBEBECEEEEF1F0F9A5C7D7197E9490E1FF73DCFF56D1FF77D7FF12
        7397629CB9AFD7EA6A7F87E0DEDEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        848484FFFFFFFFFFFFFCEEF2F3EDEEF2F0F0EDE9EEECE8F4BACBE00F758C96E6
        FF81D7FB70D5FB77D6FE166E965BA4C260667DC6D6DCFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF848484FFFFFFFFFFFFEFF0EEF2F4F4EAECEDECF2F1F6EDF0
        E0E7F0B4D2E519768BA6EFFF7FDDFA6FDAFF7ADBFF1B73912F61759EB8C4FDEF
        FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848484FFFFFFFFFFFFE4E8E3DADFDED2
        DBDED9D9D9DCE2DDE6DEDED1D7DE90C3CD087B88AAECFF80DDFC7AD8F584E4F4
        118285738090D2DFEFF5F5F5FFFFFFFFFFFFFFFFFFFFFFFF848484FFFFFFFFFF
        FFFEF5F1F1F3F3ECF1F4F9F6F8FEEFECF7F5EDEFF6F3FDEEF6BAC8EC237692B5
        EEFF8EE8F9495769C8C9D7505466B1BCD2ECECECF5F5F5FFFFFFFFFFFFFFFFFF
        848687FDFFFFFDFFFFF2F4F5F4F6F7F3F5F6F3F5F5F5F5F5F7F7F7F8F9F7F4F5
        F3ECFEF1C2D1D44C575FEFEDF3F8F2E7595E4FB4CED50B0CAABAC4FAE5DBF9FF
        FFFFFFFFFFFFFFFF848687FBFDFEFCFEFFF6F8F9F7F9FAF4F6F7F2F4F5F3F5F5
        F7F7F7F8F8F8F6F6F6F7EEFBF6F8F9B3B4BE615D63ECE9EBE5F5EE8183FF4251
        FB161791C8C8F0FFFFFFFFFFFFFFFFFF868686FEFEFEFEFEFEE4E6E7E3E5E6E1
        E3E4DEE0E1E1E1E1E2E2E2E2E2E2E2E2E2E8E7D9E1DDE3E3EADBA7ACA3595965
        B9B8F8888DFF5569FF0B05B2C1CBFAFFFFFFFFFFFFFFFFFF878584FFFFFEFFFF
        FEFDFBFAFCFAFAFDFBFBF9F9F9FAFAFAFAFAFAF7F7F7FAF9FBFAF8F8DADCDDD2
        D8D3DEE6DBCEC6F5270F97B7D1FF8CB5FA1714A0E4EDFFFFFFFFFFFFFFFFFFFF
        878584FFFFFCFDFAF6FFFEF9FFFBF8FFFDFAFFFDF9FFFEFDFFFDFCFCFAFAFFFF
        FFDFDFCD999698848387838B7A89938D8694AA160C9C0A09A7D1D7FFF9F9FFFF
        FFFFFFFFFFFFFFFF898682FFFEF9F3EFEAF4EBE2F2E9E0F2EAE3EFE7E0EFE9E4
        EEE9E6EDE8E5FCF7F496959EFCFFFBF4F3FCF4F3FDEFF2F68B8FA1D4D6FFD2DF
        FFF0FCEAFFFFFFFFFFFFFFFFFFFFFFFF8C8883FFFFFAEFE9E2FBEEE0F8EADEFA
        EEE2F3E9DFF4EBE2F2EAE3F3EBE4FFFFFA7E877DF6FAFBF6FBF2F7F3F986897A
        CDCAD3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8D8984FFFFF9EFE9
        E2FCECDCFAEBDBFFF0E3FAECE0F9EDE3F6EBE3F4EBE2FFFFF98C7D92FAF2F3FA
        ECF88B8880BFC2B3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        868686FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF9A9A9AEAEAEA8D8D8DB6B6B6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF8686868E8E8E828282858585858585858585858585858585
        8585858585858585857E7E7E929292C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Margin = 1
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      OnClick = SpeedButton1Click
    end
    object Bevel2: TBevel
      Left = 74
      Top = 16
      Width = 9
      Height = 29
      Shape = bsLeftLine
    end
    object SBNavOnMark: TSpeedButton
      Left = 144
      Top = 16
      Width = 29
      Height = 29
      Hint = #1053#1072#1074#1080#1075#1072#1094#1080#1103' '#1085#1072' '#1074#1099#1073#1088#1072#1085#1085#1091#1102' '#1084#1077#1090#1082#1091
      AllowAllUp = True
      GroupIndex = 1
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C006000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8A8FF9A9A
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        9A9AFF5151FF5151FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF06071A000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFA8A8FFA8A8FF5151FF5151FF5151FF9A9AFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF03030C000000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFA8A8FF5151FF5151FF5151FF5151FF5151FF5151FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF080A1F020209FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF9A9AFF5151FF5151FF5151FF5151FF5151FF5151
        FF5151FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF16
        1B4E10133BFFFFFFFFFFFFFFFFFF5151FF9A9AFF5151FF5151FF5151FF5151FF
        5151FF5151FF5151FF5151FF9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF1E2461202665FFFFFFFFFFFF5151FF5151FF5151FF5151FF51
        51FF5151FF5151FF5151FF5151FF5151FF5151FF5151FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000002C3488333DA1000001FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF5151FFA8A8FF9A9AFF9A9AFF9A9AFF5151FF5151FF9A9AFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF04050B3E49BD4754E1020309
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF15183B53
        61F45463FF181D4B0A0C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF0000023B439F5B6AFF5563FE3B46B6000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF0000002125536271FD5562F8515EF65766FF1F245E000000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF03040B181B39626FE95F6DFE5D6BFF5A68FF5360FB
        5160F0121536010106FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0E101F5B66D26A77FF6370FB45
        4FBC3E47B25766FA5563FF4856DD070917FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0101003D42727D89
        FF626EF76B79FD2B307020255C606FFF515DF35968FF272F7A000000FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000006369A78792FD6773F77482FF333982262B686270FE5461F55867FE3A44
        AE000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000006E74AC949EFE747EF94D57B72A2F6A292F6D6573FE
        5764F65B6AFE3D48B3020202FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000005B6089A4ADFF848EFD3F468A00
        00012B306E6875FF5965F4606FFF343C92000000FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF232534A1A9
        F5939CFF8691FF4047943941926774FC5E6BFD606EFD131634FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF0102043F425DA6AEF9949EFF7F8BFF6E7BFF6B78FF6B78FE282E630000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF090A12323448757BB07C85DC6B75DD525BB5
        202347000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF05060E00000014
        161D12131E000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      ParentShowHint = False
      ShowHint = True
      OnClick = SBNavOnMarkClick
    end
    object MarksListBox: TCheckListBox
      Left = 8
      Top = 48
      Width = 257
      Height = 265
      OnClickCheck = MarksListBoxClickCheck
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
      OnKeyUp = MarksListBoxKeyUp
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 320
      Width = 41
      Height = 17
      Caption = #1042#1089#1077
      TabOrder = 1
      OnClick = CheckBox1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 201
    Height = 345
    Caption = ' '#1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1084#1077#1090#1086#1082' '
    TabOrder = 1
    object BtnDelKat: TSpeedButton
      Left = 72
      Top = 16
      Width = 29
      Height = 29
      Hint = #1059#1076#1072#1083#1080#1090#1100
      Glyph.Data = {
        26040000424D2604000000000000360000002800000012000000120000000100
        180000000000F003000000000000000000000000000000000000FF00FFFF00FF
        E6E6E6DCDCDCD6D6D6D8D8D8D9D9D9D9D9D9D2D6D1D3D6DED0D5EAC5D1DDC2D1
        D3D4DAD5FF00FFFF00FFFF00FFFF00FF00008D8D8D8585858383838282828585
        8586868685858583838385848683967B4A469F1F0BB82517BD667E8A665FB020
        12BE402CCB877BDF0000848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFCECF5FF3827C45D62FB5D66FF484BD11904B7515FFF5C5DFF3131A3
        0000858585FEFEFEFFFFFFEBEBEBEDEDEDECECECEAEAEAE9E9E9F2EBE8D7F1E1
        828CDA0D00D1798AF94249F64847FF7885FF1107C58A8AE40000858585FFFFFF
        FDFDFDE1E1E1D6D6D6D4D4D4D5D5D5D7D7D7D2D6CAD1DFDEC1D8D4383BD30300
        BA4233FF4751FF0C00C73849C1FF00FF0000858585FDFDFDFFFFFFECECECEEEE
        EEEEEEEEEEEEEEEEEEEEFFE9FCE3EDDC9D8FDD0703C67F85FF8888FA6266F47C
        86FF0F09BA8E88E10000858585FFFFFFFFFFFFEEEEEEEEEEEEEDEDEDEEEEEEEE
        EEEEF2E8F4E4F1E32D1BD4ACA1FD8381FF0800C49DB4F87979FF949BFF2D29B8
        0000858585FCFCFCFFFFFFEFEFEFF2F2F2F1F1F1F0F0F0F0F0F0E7EFFCE1F0FF
        2619C3BBC6FFBFCDFE4C4AD91000C4BAD1FEB9CDF6271EC20000858585FFFFFF
        FEFEFEE4E4E4DBDBDBD9D9D9DBDBDBDEDEDEDCDFD0D6DED48386DB2C20B82B1E
        CDEDFDFF524C993B19C43B1EC8988DED0000858585FFFFFEFFFFFEF5F5F5F6F8
        F8F2F4F5F2F4F5F3F5F6F0F2F3F7F9FAF0F2F3F6F8F9F4F4F4FFFFFF848484D8
        D8D8FF00FFFF00FF0000858585FDFDFDFFFFFFF7F7F7F9FBFCF7F9FAF7F9FAF8
        FAFBF5F7F8F6F8F9F3F5F6F8F8F8F7F7F7FFFFFF858585D8D8D8FF00FFFF00FF
        0000858585FFFFFFFDFDFDEDEDEDDFE1E2DDDFE0DEE0E1DFE1E2E3E3E3DEDEDE
        E2E2E2DFDFDFE0E0E0E8E8E8838383DADADAFF00FFFF00FF0000858585FFFEFF
        FFFFFFFBFBFBFBFBFBFEFCFCFEFCFCFCFAF9FDFBFAFCFAF9FCFAF9DCDCDCD9D9
        D9DDDDDD868686E1E1E1FF00FFFF00FF0000858585FFFFFFFFFEFEFEFCFBFFFE
        FAFFFEFBFFFCF9FFFBF6FCF9F5FFFFFBDDDBDA959392858585949494848687EB
        EBEBFF00FFFF00FF0000858585FFFEFBF4EFECEEE9E6EEE6DFF1E9E2F4EBE2F5
        ECE3EEEAE5FFFFFA94918DFFFFFEFBF9F8EDEFF0969899FF00FFFF00FFFF00FF
        0000858585FFFFF9F5ECE3F3E8E0FAECE0FDEDE0FDEEDEFFEFDFF4EEE7FFFEF7
        898580FEFBF7F4F2F1BCBEBFFF00FFFF00FFFF00FFFF00FF0000828282FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFFFFFF939393F0F0F08686
        86FF00FFFF00FFFF00FFFF00FFFF00FF00008D8D8D8585858585858585858585
        858585858585858585858A8A8A8080808080809B9B9BFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF0000}
      Margin = 3
      ParentShowHint = False
      ShowHint = True
      OnClick = BtnDelKatClick
    end
    object BtnEditCategory: TSpeedButton
      Left = 40
      Top = 16
      Width = 29
      Height = 29
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C006000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFF2F2F2F3F3F3E3E3E3CEDBD9D5D3D3EADDDFDBCFCFDFDAD9
        E2DEDDE0D6D6E4CFD1D3D9D8D4DAD9D7DCDBD9DBDBD2D4D4DCDCDCFAF8F8FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F8E8E8E7F7F7F858C8987818293
        858B2D292F3E4B536F8A945D77836679887981807F85847C82818085848C8E8E
        7F7F7FE0DEDEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8A8A8AF5F5F5FFFF
        FFFDFEFCFFFEFFFBF3FA101C28001725337B8D2B799058A3BDD3DBDAF0F8F7FA
        FFFFFBFFFFF9FBFB8C8C8CDAD8D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        848484FFFFFFFFFFFFFEE5E1EBF2EDD0E7E93A506932739979D4FF7CD3FF1575
        996296B49BBFCFCEE5E7FFFDFDFFFEFF8A7F82D5DAD9FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF848484FFFFFFFFFFFFDBF0E8F1E4E2DFE8EC448C969EE7FF
        72D4FC5AD5FB6CD1F8076E955790AFB6C5D5F5F8FCF2FDFB848988D3D8D6FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848484FFFFFFFFFFFFD8E7E3D3DAD7D6
        D5D798B8C3187E907ADFFF6FDBFF60D2FB6ED3FF13719C4E90A9BFD6E6F6F0FB
        888385DAD9D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848484FFFFFFFFFF
        FFF0E9ECEBEBEBECEEEEF1F0F9A5C7D7197E9490E1FF73DCFF56D1FF77D7FF12
        7397629CB9AFD7EA6A7F87E0DEDEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        848484FFFFFFFFFFFFFCEEF2F3EDEEF2F0F0EDE9EEECE8F4BACBE00F758C96E6
        FF81D7FB70D5FB77D6FE166E965BA4C260667DC6D6DCFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF848484FFFFFFFFFFFFEFF0EEF2F4F4EAECEDECF2F1F6EDF0
        E0E7F0B4D2E519768BA6EFFF7FDDFA6FDAFF7ADBFF1B73912F61759EB8C4FDEF
        FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848484FFFFFFFFFFFFE4E8E3DADFDED2
        DBDED9D9D9DCE2DDE6DEDED1D7DE90C3CD087B88AAECFF80DDFC7AD8F584E4F4
        118285738090D2DFEFF5F5F5FFFFFFFFFFFFFFFFFFFFFFFF848484FFFFFFFFFF
        FFFEF5F1F1F3F3ECF1F4F9F6F8FEEFECF7F5EDEFF6F3FDEEF6BAC8EC237692B5
        EEFF8EE8F9495769C8C9D7505466B1BCD2ECECECF5F5F5FFFFFFFFFFFFFFFFFF
        848687FDFFFFFDFFFFF2F4F5F4F6F7F3F5F6F3F5F5F5F5F5F7F7F7F8F9F7F4F5
        F3ECFEF1C2D1D44C575FEFEDF3F8F2E7595E4FB4CED50B0CAABAC4FAE5DBF9FF
        FFFFFFFFFFFFFFFF848687FBFDFEFCFEFFF6F8F9F7F9FAF4F6F7F2F4F5F3F5F5
        F7F7F7F8F8F8F6F6F6F7EEFBF6F8F9B3B4BE615D63ECE9EBE5F5EE8183FF4251
        FB161791C8C8F0FFFFFFFFFFFFFFFFFF868686FEFEFEFEFEFEE4E6E7E3E5E6E1
        E3E4DEE0E1E1E1E1E2E2E2E2E2E2E2E2E2E8E7D9E1DDE3E3EADBA7ACA3595965
        B9B8F8888DFF5569FF0B05B2C1CBFAFFFFFFFFFFFFFFFFFF878584FFFFFEFFFF
        FEFDFBFAFCFAFAFDFBFBF9F9F9FAFAFAFAFAFAF7F7F7FAF9FBFAF8F8DADCDDD2
        D8D3DEE6DBCEC6F5270F97B7D1FF8CB5FA1714A0E4EDFFFFFFFFFFFFFFFFFFFF
        878584FFFFFCFDFAF6FFFEF9FFFBF8FFFDFAFFFDF9FFFEFDFFFDFCFCFAFAFFFF
        FFDFDFCD999698848387838B7A89938D8694AA160C9C0A09A7D1D7FFF9F9FFFF
        FFFFFFFFFFFFFFFF898682FFFEF9F3EFEAF4EBE2F2E9E0F2EAE3EFE7E0EFE9E4
        EEE9E6EDE8E5FCF7F496959EFCFFFBF4F3FCF4F3FDEFF2F68B8FA1D4D6FFD2DF
        FFF0FCEAFFFFFFFFFFFFFFFFFFFFFFFF8C8883FFFFFAEFE9E2FBEEE0F8EADEFA
        EEE2F3E9DFF4EBE2F2EAE3F3EBE4FFFFFA7E877DF6FAFBF6FBF2F7F3F986897A
        CDCAD3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8D8984FFFFF9EFE9
        E2FCECDCFAEBDBFFF0E3FAECE0F9EDE3F6EBE3F4EBE2FFFFF98C7D92FAF2F3FA
        ECF88B8880BFC2B3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        868686FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF9A9A9AEAEAEA8D8D8DB6B6B6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF8686868E8E8E828282858585858585858585858585858585
        8585858585858585857E7E7E929292C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Margin = 1
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      OnClick = BtnEditCategoryClick
    end
    object BtnAddCategory: TSpeedButton
      Left = 8
      Top = 16
      Width = 29
      Height = 29
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      Glyph.Data = {
        B6050000424DB605000000000000360000002800000015000000160000000100
        1800000000008005000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00FF00FF818181
        8B8B8B8383838686868585858686868686868686868686868686868686868686
        868686864B8E57307C3C33803D609667FF00FFFF00FFFF00FF00FF00FF858585
        EFF3F4EFF3F4EFF3F4FEFEFEEFF3F4EFF3F4EFF3F4EFF3F4EFF3F4EFF3F4EFF3
        F4EFF3F429973E49BF5A44B7502F7F38FF00FFFF00FFFF00FF00FF00FF858585
        EFF3F4EFF3F4E8E8E8E7E7E7E5EBE0E5ECE7ECEAF0F0E0F1EEE1EFE8ECEDDFE5
        DAF1EDDA007D2B49BB4A4ECA48017C22FF00FFFF00FFFF00FF00FF00FF828282
        EFF3F4EFF3F4EDEDEDEAEAEAEFEEE4E2E9E4E5E9EAF4EAF0EAEEE89ECFAF2B89
        5006772D0A7F2433C53D2ABB310C8320007A262E8D4AFF00FF00FF00FF868686
        EFF3F4FBFBFBE0E0E0D8D8D8DBD4D7D9D9DFD0D3D8D3D9D4C0DFC236864347BC
        5545C44939BC3D22B42616BD2E50C04A36B9404DCE4F21943700FF00FF848484
        EFF3F4EFF3F4ECECECECECECEEEBE6EFF2F0EAECEDEDF1ECD6F4DB49905783E1
        8A8BEA8179E1823EAD392AB42D82DE74A1E69688DD8D358A4C00FF00FF848484
        EFF3F4EFF3F4EDEDEDEDEDEDF7EBF1E8E4EAF3E9F5FDECF5EEEEE899CCA72D8E
        4E057D2C00831D3AC53C40B431098724077C2D269152FF00FF00FF00FF828282
        EFF3F4EFF3F4F0F0F0EFEFEFECFAEFE4F4EDF0F4F5FBEAF3FAE9F2F8FAFBDBE9
        E3E7F8EB0579334DBA4656C845007F29FF00FFFF00FFFF00FF00FF00FF868686
        EFF3F4FEFEFEE3E3E3DCDCDCE5DADDE0DBDDDDD8DAE5DCDFE7E2E4CFD3D4ECE4
        E5F4D6DB20934990EA8B87EC82267A3AFF00FFFF00FFFF00FF00FF00FF848484
        EFF3F4EFF3F4F1F1F1F3F3F3F0F2F2EBF9F5EAF6F0F6F3EEF5F1ECEFF8F5DEEE
        EDEAF6FABAD4B63193471C9348657E6AFF00FFFF00FFFF00FF00FF00FF858486
        FAFCFDFAFEFFEFF3F4F2F6F7F2F4F4F2F4F4F5F5F5F9F9F9F3F1F1F7F2F3FEF9
        FAF7F2F3F3F3F3EFF3F4FBFBFB898989FF00FFFF00FFFF00FF00FF00FF848385
        EFF3F4FDFFFFF6F8F8F4F9F8F4F6F6F5F7F7F8F8F8F7F7F7F8F6F6EFF3F4F0EE
        EEFAF8F8F8F8F8EFF3F4EFF3F4818181FF00FFFF00FFFF00FF00FF00FF868686
        EFF3F4FCFCFCEBECEAE3E4E2E1E1E1E0E0E0E1E1E1E1E1E1DEDDDFE4E3E5E0DF
        E1E5E4E6E1E1E1EBEBEBE4E4E47F7F7FFF00FFFF00FFFF00FF00FF00FF828282
        FFFFFEFFFFFEFFFCF8FBF8F4FBF9F8FCFAF9FCFAFAFCFCFCFAF9FBF7F6F8FDFF
        FFD3D4D8DDDDDDD9D9D9E0E0E0828282FF00FFFF00FFFF00FF00FF00FF858382
        FFFFFCFFFEF9FFFFFAFFFEF9FFFDF8FFFDFAFEF9F6FDF9F8FFFEFEFDFDFDCDCF
        D09A9C9D838383848484979797868686FF00FFFF00FFFF00FF00FF00FF888685
        FFFEF9F3EDE8F1E9E2F0E7DEF2E7DFF5ECE3F3EBE4EEE8E3ECE9E5FBF9F8A9A9
        A9F1F3F3F8F8F8FDFDFDF0F0F0909090FF00FFFF00FFFF00FF00FF00FF86837F
        FFFDF8F1E9E2F5ECE3F6ECE2FEF0E4F9EBDFF2E8DEF3EAE1F2ECE5FFFFFB8382
        7EFFFFFEF2F2F2ECECEC898989FF00FFFF00FFFF00FFFF00FF00FF00FF8B8884
        FFFFFBF6EDE4F6ECE2F6EAE0F6E6D6FFEFE2FDEFE3F5EBE1F0E9E0FFFFFB8784
        7FF5F4F0F5F5F5858585FF00FFFF00FFFF00FFFF00FFFF00FF00FF00FF868686
        FBFBFBFEFEFEFEFEFEFDFDFDFDFDFDFCFCFCEFF3F4EFF3F4EFF3F4F9F9F99E9E
        9EEDEDED828282FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00FF00FF858585
        8E8E8E8484848686868787878787878383838484848686868282828D8D8D7878
        78959595FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00}
      Margin = 1
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      OnClick = BtnAddCategoryClick
    end
    object KategoryListBox: TCheckListBox
      Left = 8
      Top = 48
      Width = 185
      Height = 265
      OnClickCheck = KategoryListBoxClickCheck
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
      OnKeyUp = KategoryListBoxKeyUp
      OnMouseUp = KategoryListBoxMouseUp
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 320
      Width = 41
      Height = 17
      Caption = #1042#1089#1077
      TabOrder = 1
      OnClick = CheckBox2Click
    end
  end
  object Button1: TButton
    Left = 496
    Top = 8
    Width = 75
    Height = 25
    Caption = #1048#1084#1087#1086#1088#1090
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 496
    Top = 80
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 3
    OnClick = Button2Click
  end
  object RBall: TRadioButton
    Left = 8
    Top = 384
    Width = 145
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1077' '#1084#1077#1090#1082#1080
    TabOrder = 4
  end
  object RBchecked: TRadioButton
    Left = 8
    Top = 368
    Width = 225
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1091#1082#1072#1079#1072#1085#1085#1099#1077' '#1084#1077#1090#1082#1080
    TabOrder = 5
  end
  object RBnot: TRadioButton
    Left = 8
    Top = 400
    Width = 145
    Height = 17
    Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1084#1077#1090#1082#1080
    TabOrder = 6
  end
  object Button3: TButton
    Left = 496
    Top = 40
    Width = 75
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 7
    OnClick = Button3Click
  end
  object OpenDialog: TOpenDialog
    Left = 544
    Top = 384
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.kml'
    Filter = 
      'Google KML files (*.kml)|*.kml|OziExplorer Track Point File Vers' +
      'ion 2.1 (*.plt)|*.plt'
    Left = 504
    Top = 384
  end
end
