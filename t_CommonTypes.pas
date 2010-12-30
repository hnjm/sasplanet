unit t_CommonTypes;

interface

type
  TTileSource = (tsInternet,tsCache,tsCacheInternet);

  TMarksShowType = (mshAll = 1, mshChecked = 2, mshNone = 3);

  { ������ ����������� ����������
  dsfKmAndM - � ���� 12 �� 299 �
  dsfSimpleKM - � ���� 12.299 ��
  }
  TDistStrFormat = (dsfKmAndM = 0, dsfSimpleKM = 1);

  TDegrShowFormat = (dshCharDegrMinSec = 0, dshCharDegrMin = 1, dshCharDegr = 2, dshSignDegrMinSec = 3, dshSignDegrMin = 4, dshSignDegr = 5);

implementation

end.
