unit UnitTDataTLink;

{

TestProgram/Optimization Project for TData and TLink

version 0.02 created on 29 october 2021 by Skybuck Flying

TData contains an array of 32 bytes, in other words 256 bits.
TLink contains an array of 256 pointers.

The mission of this project is to optimize the IsEmpty and IsFull functions
to run as fast as possible on modern x86/x64 processors.

Bonus would be to optimize Empty and Full routines, however beware
the TLink structure uses special pointer values for empty and full.

The verification routines do not need to be optimized and should not
be optimized and are only there to verify any optimized code.

I will sure this code in github for easy downloading and uploading.

Would be cool to get some help with optimizing this code.

The original code used a mCount : byte; member to optimize the code
however this increases the TData structure to 33 bytes which could
be causing misalignment and consumes 3% more memory.

The TLink structure would also fit better if mCount is illiminated.

Both structures contained a mCount : byte variable and have been removed.

Now the same functionality to check for empty and full should be implemented
with as fast as code as possible without using any extra member fields
for the structures to keep them memory efficient like this.

Perhaps these link functions can be optimized with AVX-512 or so ?

}

{

version 0.03 created on 29 october 2021 by Skybuck Flying

Console program turned into multi-device-application project for
multi-platform support.

Project and Source files seperated into seperate folders to avoid
file clutter.

Only WIN32 platform currently implemented.

Other platforms possible thanks to multi-device-project/applicaation.

For some reason it was not possible to add platforms to a console project.

So I modified code so it can work with a multi-device-application, this
added a lot of platforms.

WIN64 platform support is desired !

The rest would be a bonus !

}

interface

uses
	Classes; // for TStrings

type
	TData = packed record
		mData : packed array[0..31] of byte;

		procedure Empty;
		procedure Full;

		function IsEmpty : boolean;
		function IsFull : boolean;

		// debug routines
		function VerifyIsEmpty : boolean;
		function VerifyIsFull : boolean;
		function VerifyOne : boolean;
		function VerifyRandomButOne : boolean;
		procedure VerifyAll;
	end;

	TLink = packed record
		mLink : packed array[0..255] of pointer;

		procedure Empty;
		procedure Full;

		function IsEmpty : boolean;
		function IsFull : boolean;

		// debug routines
		function VerifyIsEmpty : boolean;
		function VerifyIsFull : boolean;
		function VerifyOne : boolean;
		function VerifyRandomButOne : boolean;
		procedure VerifyAll;
	end;

procedure MainTestProgram( ParaOutput : TStrings );

implementation

uses
	SysUtils; // for IntToStr

const
	ConstDataTestLoops = 1000000; // one million ! =D
	ConstLinkTestLoops =  100000; // one hundred thousand ! =D

var
	const_empty : pointer;
	const_full : pointer;

var
	vOutput : TStrings;

procedure OutputMessage( ParaString : string );
begin
	vOutput.Add( ParaString );
end;

// only works on win32 platform, need win64 platform versions !

{$ifdef WIN32}
// unlocked versions (multi-threading-unsafe)
procedure BitReset( ParaMemory : pointer; ParaBitIndex : integer );
asm
	btr [eax], edx
end;

procedure BitSet( ParaMemory : pointer; ParaBitIndex : integer );
asm
	bts [eax], edx
end;

// locked versions (multi-threading-safe)
procedure LockedBitReset( ParaMemory : pointer; ParaBitIndex : integer );
asm
	LOCK btr [eax], edx
end;

procedure LockedBitSet( ParaMemory : pointer; ParaBitIndex : integer );
asm
	LOCK bts [eax], edx
end;
{$endif}

{$ifdef WIN64}
// unlocked versions (multi-threading-unsafe)
// optimize me ?
procedure BitReset( ParaMemory : pointer; ParaBitIndex : integer );
begin
	// to be implemented
	ERROR NOT IMPLEMENTED
end;

procedure BitSet( ParaMemory : pointer; ParaBitIndex : integer );
begin
	// to be implemented
	ERROR NOT IMPLEMENTED
end;

// not really required for this test program but would be nice to have a 64 bit version of this as well.
procedure LockedBitReset( ParaMemory : pointer; ParaBitIndex : integer );
begin

end;

procedure LockedBitSet( ParaMemory : pointer; ParaBitIndex : integer );
begin

end;
{$endif}

{$ifdef WIN32}
procedure TData.Empty;
type
	TUInt32Array = packed array[0..7] of UInt32;
begin
	TUInt32Array(mData)[0] := 0;
	TUInt32Array(mData)[1] := 0;
	TUInt32Array(mData)[2] := 0;
	TUInt32Array(mData)[3] := 0;
	TUInt32Array(mData)[4] := 0;
	TUInt32Array(mData)[5] := 0;
	TUInt32Array(mData)[6] := 0;
	TUInt32Array(mData)[7] := 0;
end;
{$endif}

{$ifdef WIN64}
procedure TData.Empty;
type
	TUInt64Array = packed array[0..3] of UInt64;
begin
	TUInt64Array(mData)[0] := 0;
	TUInt64Array(mData)[1] := 0;
	TUInt64Array(mData)[2] := 0;
	TUInt64Array(mData)[3] := 0;
end;
{$endif}

{$ifdef WIN32}
procedure TData.Full;
type
	TUInt32Array = packed array[0..7] of longword;
begin
	//                         11223344
	TUInt32Array(mData)[0] := $FFFFFFFF;
	TUInt32Array(mData)[1] := $FFFFFFFF;
	TUInt32Array(mData)[2] := $FFFFFFFF;
	TUInt32Array(mData)[3] := $FFFFFFFF;
	TUInt32Array(mData)[4] := $FFFFFFFF;
	TUInt32Array(mData)[5] := $FFFFFFFF;
	TUInt32Array(mData)[6] := $FFFFFFFF;
	TUInt32Array(mData)[7] := $FFFFFFFF;
end;
{$endif}

{$ifdef WIN64}
procedure TData.Full;
type
	TUInt64Array = packed array[0..3] of UInt64;
begin
	//                         1122334455667788
	TUInt64Array(mData)[0] := $FFFFFFFFFFFFFFFF;
	TUInt64Array(mData)[1] := $FFFFFFFFFFFFFFFF;
	TUInt64Array(mData)[2] := $FFFFFFFFFFFFFFFF;
	TUInt64Array(mData)[3] := $FFFFFFFFFFFFFFFF;
end;
{$endif}

{$ifdef WIN32}
function TData.IsEmpty : boolean;
type
	TUInt32Array = packed array[0..7] of longword;
var
	vResult : longword;
begin
	result := False;

	vResult :=
		TUInt32Array(mData)[0] or
		TUInt32Array(mData)[1] or
		TUInt32Array(mData)[2] or
		TUInt32Array(mData)[3] or
		TUInt32Array(mData)[4] or
		TUInt32Array(mData)[5] or
		TUInt32Array(mData)[6] or
		TUInt32Array(mData)[7];

	if vResult = 0 then
	begin
		result := True;
	end;
end;
{$endif}

{$ifdef WIN64}
function TData.IsEmpty : boolean;
type
	TUInt64Array = packed array[0..3] of UInt64;
var
	vResult : UInt64;
begin
	result := False;

	vResult :=
		TUInt64Array(mData)[0] or
		TUInt64Array(mData)[1] or
		TUInt64Array(mData)[2] or
		TUInt64Array(mData)[3];

	if vResult = 0 then
	begin
		result := True;
	end;
end;
{$endif}

{$ifdef WIN32}
function TData.IsFull : boolean;
type
	TUInt32Array = packed array[0..7] of longword;
var
	vResult : UInt64;
begin
	result := False;

	vResult :=
		TUInt32Array(mData)[0] and
		TUInt32Array(mData)[1] and
		TUInt32Array(mData)[2] and
		TUInt32Array(mData)[3] and
		TUInt32Array(mData)[4] and
		TUInt32Array(mData)[5] and
		TUInt32Array(mData)[6] and
		TUInt32Array(mData)[7];

	//            11223344
	if vResult = $FFFFFFFF then
	begin
		result := True;
	end;
end;
{$endif}

{$ifdef WIN64}
function TData.IsFull : boolean;
type
	TUInt64Array = packed array[0..3] of UInt64;
var
	vResult : UInt64;
begin
	result := False;

	vResult :=
		TUInt64Array(mData)[0] and
		TUInt64Array(mData)[1] and
		TUInt64Array(mData)[2] and
		TUInt64Array(mData)[3];

	//            1122334455667788
	if vResult = $FFFFFFFFFFFFFFFF then
	begin
		result := True;
	end;
end;
{$endif}

// TData verification routines

function TData.VerifyIsEmpty : boolean;
var
	vIndex : integer;
begin
	result := True;
	for vIndex := 0 to 31 do
	begin
		if mData[vIndex] <> 0 then
		begin
			result := False;
		end;
	end;
end;

function TData.VerifyIsFull : boolean;
var
	vIndex : integer;
begin
	result := True;
	for vIndex := 0 to 31 do
	begin
		if mData[vIndex] <> 255 then
		begin
			result := False;
		end;
	end;
end;

function TData.VerifyOne : boolean;
var
	vIndex : integer;
begin
	result := True;
	for vIndex := 0 to 255 do
	begin
		Empty;

		BitSet(@mData[vIndex div 8], vIndex mod 8);

		if not
		(
			(
				(not IsEmpty) and (not VerifyIsEmpty)
			)
				and
			(
				(not IsFull) and (not VerifyIsFull)
			)
		) then
		begin
			result := False;
		end;
	end;
end;

// heavy duty verification
function TData.VerifyRandomButOne : boolean;
var
	vTestLoop : integer;
	vTestIndex : integer;
	vIndex : integer;
begin
	result := True;

	for vTestLoop := 1 to ConstDataTestLoops do
	begin
		Empty;

		// missing one index ;)
		for vIndex := 1 to 255 do
		begin
			vTestIndex := Random(256); // gives range 0 to 255

			BitSet( @mData[vTestIndex div 8], vTestIndex mod 8 );
		end;

		if IsEmpty or VerifyIsEmpty or IsFull or VerifyIsFull then
		begin
			result := False;
			OutputMessage('TData.VerifyRandomButOne: Error detected at TestLoop: ' + IntToStr(vTestLoop) );
			break;
		end;
	end;

end;


procedure TData.VerifyAll;
var
	vData : TData;
begin
	vData.Empty;

	if vData.IsEmpty = vData.VerifyIsEmpty then
	begin
		OutputMessage('Verified: vData.IsEmpty');
	end else
	begin
		OutputMessage('Verification Error: vData.IsEmpty');
	end;

	vData.Full;

	if vData.IsFull = vData.VerifyIsFull then
	begin
		OutputMessage('Verified: vData.IsFull');
	end else
	begin
		OutputMessage('Verification Error: vData.IsFull');
	end;

	if vData.VerifyOne then
	begin
		OutputMessage('Verified: vData one bit set and not IsEmpty and not IsFull');
	end else
	begin
		OutputMessage('Verification Error: vData one bit set and not IsEmpty and not IsFull');
	end;

	if vData.VerifyRandomButOne then
	begin
		OutputMessage('Verified: vData.VerifyRandomButOne' );
	end else
	begin
		OutputMessage('Verification Error: vData.VerifyRandomButOne' );
	end;

end;

// TLink

procedure TLink.Empty;
var
	vIndex : integer;
begin
	for vIndex := 0 to 255 do
	begin
		mLink[vIndex] := const_empty;
	end;

end;

procedure TLink.Full;
var
	vIndex : integer;
begin
	for vIndex := 0 to 255 do
	begin
		mLink[vIndex] := const_full;
	end;
end;

function TLink.IsEmpty : boolean;
var
	vIndex : integer;
begin
	result := True;
	for vIndex := 0 to 255 do
	begin
		if mLink[vIndex] <> const_empty then
		begin
			result := False;
			Break;
		end;
	end;
end;

function TLink.IsFull : boolean;
var
	vIndex : integer;
begin
	result := True;
	for vIndex := 0 to 255 do
	begin
		if mLink[vIndex] <> const_full then
		begin
			result := False;
			Break;
		end;
	end;
end;

// TLink verification routines

function TLink.VerifyIsEmpty : boolean;
var
	vIndex : integer;
begin
	result := True;
	for vIndex := 0 to 255 do
	begin
		if mLink[vIndex] <> const_empty then
		begin
			result := False;
		end;
	end;
end;

function TLink.VerifyIsFull : boolean;
var
	vIndex : integer;
begin
	result := True;
	for vIndex := 0 to 255 do
	begin
		if mLink[vIndex] <> const_full then
		begin
			result := False;
		end;
	end;
end;

function TLink.VerifyOne : boolean;
var
	vIndex : integer;
begin
	result := True;
	for vIndex := 0 to 255 do
	begin
		Empty;

		if SizeOf(Pointer) = 4 then
		begin
			mLink[vIndex] := pointer($11223344);
		end else
		if SizeOf(Pointer) = 8 then
		begin
			mLink[vIndex] := pointer($1122334455667788);
		end;

		if not
		(
			(
				(not IsEmpty) and (not VerifyIsEmpty)
			)
				and
			(
				(not IsFull) and (not VerifyIsFull)
			)
		) then
		begin
			result := False;
		end;
	end;
end;

// heavy duty verification
function TLink.VerifyRandomButOne : boolean;
var
	vTestLoop : integer;
	vTestIndex : integer;
	vIndex : integer;
begin
	result := True;

	for vTestLoop := 1 to ConstLinkTestLoops do
	begin
		Empty;

		// missing one index ;)
		for vIndex := 1 to 255 do
		begin
			vTestIndex := Random(256); // gives range 0 to 255

			if SizeOf(Pointer) = 4 then
			begin
				mLink[vTestIndex] := pointer($11223344);
			end else
			if SizeOf(Pointer) = 8 then
			begin
				mLink[vTestIndex] := pointer($1122334455667788);
			end;
		end;

		if IsEmpty or VerifyIsEmpty or IsFull or VerifyIsFull then
		begin
			result := False;
			OutputMessage('TLink.VerifyRandomButOne: Error detected at TestLoop: ' + IntToStr(vTestLoop) );
			break;
		end;
	end;

end;

procedure TLink.VerifyAll;
var
	vLink : TLink;
begin
	vLink.Empty;

	if vLink.IsEmpty = vLink.VerifyIsEmpty then
	begin
		OutputMessage('Verified: vLink.IsEmpty');
	end else
	begin
		OutputMessage('Verification Error: vLink.IsEmpty');
	end;

	vLink.Full;

	if vLink.IsFull = vLink.VerifyIsFull then
	begin
		OutputMessage('Verified: vLink.IsFull');
	end else
	begin
		OutputMessage('Verification Error: vLink.IsFull');
	end;

	if vLink.VerifyOne then
	begin
		OutputMessage('Verified: vLink one link set and not IsEmpty and not IsFull');
	end else
	begin
		OutputMessage('Verification Error: vLink one link set and not IsEmpty and not IsFull');
	end;

	if vLink.VerifyRandomButOne then
	begin
		OutputMessage('Verified: vLink.VerifyRandomButOne' );
	end else
	begin
		OutputMessage('Verification Error: vLink.VerifyRandomButOne' );
	end;
end;

procedure MainTestProgram( ParaOutput : TStrings );
var
	vData : TData;
	vLink : TLink;
begin
	vOutput := ParaOutput;
	OutputMessage('program started');

	OutputMessage('vData.VerifyAll');
	vData.VerifyAll;
	OutputMessage('');

	OutputMessage('vLink.VerifyAll');
	vLink.VerifyAll;
	OutputMessage('');

	OutputMessage('program finished');
end;

initialization
	// should be place in unit initialization section but for now here is ok
	// or initialize to low unused pointer value like 1 and 2.
	// first 64k value range should be safe for windows virtual memory.
	const_empty := @const_empty;
	const_full := @const_full;
end.



