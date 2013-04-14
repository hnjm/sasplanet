unit i_MarkSystem;

interface

uses
  Classes,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ReadWriteState,
  i_VectorDataItemSimple,
  i_MarkFactoryConfig,
  i_ImportConfig,
  i_VectorItemSubset,
  i_Mark,
  i_MarkCategory,
  i_MarkDb,
  i_MarkCategoryDB,
  i_StaticTreeItem;

type
  IMarkSystem = interface
    ['{E974C3C0-499C-4BB0-B82E-34D39AFCBA9F}']
    function GetState: IReadWriteStateChangeble;
    property State: IReadWriteStateChangeble read GetState;

    function GetMarkDb: IMarkDb;
    property MarkDb: IMarkDb read GetMarkDb;

    function GetCategoryDB: IMarkCategoryDB;
    property CategoryDB: IMarkCategoryDB read GetCategoryDB;

    function GetMarkByStringId(const AId: string): IMark;
    function GetMarkCategoryByStringId(const AId: string): IMarkCategory;

    function ImportItemsList(
      const ADataItemList: IVectorItemSubset;
      const AImportConfig: IImportConfig;
      const ANamePrefix: string
    ): IInterfaceList;

    function GetVisibleCategories(AZoom: Byte): IInterfaceList;
    function GetVisibleCategoriesIgnoreZoom: IInterfaceList;
    procedure DeleteCategoryWithMarks(const ACategory: IMarkCategory);

    function MarkSubsetToStaticTree(const ASubset: IVectorItemSubset): IStaticTreeItem;
    function CategoryListToStaticTree(const AList: IInterfaceList): IStaticTreeItem;
  end;

implementation

end.
