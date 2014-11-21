unit uSuperEdit;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Edit;

type
  TSuperEdit = class(TEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ricardo', [TSuperEdit]);
end;

end.
