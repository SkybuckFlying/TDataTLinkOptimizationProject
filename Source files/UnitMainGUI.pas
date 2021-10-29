unit UnitMainGUI;

{

See UnitTDataTLink for source code and optimization work (in the source files folder).

}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses UnitTDataTLink;

procedure TForm1.Button1Click(Sender: TObject);
begin
	try
		Memo1.Lines.Add('Computing... please wait...');
		Application.ProcessMessages;
		UnitTDataTLink.MainTestProgram( Memo1.Lines );
		Memo1.Lines.Add('Computations done.');
	except
		on E: Exception do
			Memo1.Lines.Add(E.ClassName + ': ' + E.Message);
	end;
end;

// Output should be:
{
program started
vData.VerifyAll
Verified: vData.IsEmpty
Verified: vData.IsFull
Verified: vData one bit set and not IsEmpty and not IsFull
Verified: vData.VerifyRandomButOne

vLink.VerifyAll
Verified: vLink.IsEmpty
Verified: vLink.IsFull
Verified: vLink one link set and not IsEmpty and not IsFull
Verified: vLink.VerifyRandomButOne

program finished
}

end.
