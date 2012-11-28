unit c_InternalBrowser;

interface

const
  CSASProtocolName = 'sas';
  CSASInternalURLPrefix = CSASProtocolName + '://';
  CZmpInfoInternalDomain = 'ZmpInfo';
  CMapDataInternalDomain = 'MapData';
  CMediaDataInternalDomain = 'MediaData';
  CLastSearchResultsInternalDomain = 'SearchResults';
  CMarksSystemInternalDomain = 'Placemarks';
  CTileStorageOptionsInternalDomain = 'TileStorageOptions';
  CZmpInfoInternalURL = CSASInternalURLPrefix + CZmpInfoInternalDomain + '/';
  CMapDataInternalURL = CSASInternalURLPrefix + CMapDataInternalDomain + '/';
  CMediaDataInternalURL = CSASInternalURLPrefix + CMediaDataInternalDomain + '/';
  CLastSearchResultsInternalURL = CSASInternalURLPrefix + CLastSearchResultsInternalDomain + '/';
  CMarksSystemInternalURL = CSASInternalURLPrefix + CMarksSystemInternalDomain + '/';
  CTileStorageOptionsInternalURL = CSASInternalURLPrefix + CTileStorageOptionsInternalDomain + '/';
  CVectorItemDescriptionSuffix = 'Description';
  CVectorItemInfoSuffix = 'Info';

implementation

end.
