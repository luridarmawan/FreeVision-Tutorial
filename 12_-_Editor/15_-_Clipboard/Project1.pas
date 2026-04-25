//image image.png
(*
A clipboard has been added here, making copy and paste possible in the editor.
The clipboard is nothing more than an editor window that receives the data when you choose to copy.
This means it can even be made visible.
*)
//lineal
program Project1;

{$mode objfpc}

uses
  App,
  Objects,
  Drivers,
  Views,
  MsgBox,
  Editors,
  Dialogs,
  StdDlg,
  Menus,
  FVConsts;

(*
A command for opening the clipboard window.
*)
//code+
const
  cmNewWin = 1001;
  cmRefresh = 1002;
  cmShowClip = 1003;
//code-

(*
Here the window for the clipboard is declared.
Also, in <b>NewWindows</b> you can specify whether the window should not be displayed visibly.
*)
//code+
type
  TMyApp = object(TApplication)
    ClipWindow: PEditWindow;

    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;

    function NewWindows(FileName: ShortString; Visible: Boolean): PEditWindow;
    procedure OpenWindows;
    procedure SaveAll;
    procedure CloseAll;
  end;
//code-

var
  MyApp: TMyApp;

  function DECreateFindDialog: PDialog;
  var
    D: PDialog;
    Control: PView;
    R: TRect;
  begin
    R.Assign(0, 0, 38, 12);
    D := New(PDialog, Init(R, 'Find'));
    with D^ do begin
      Options := Options or ofCentered;

      R.Assign(3, 3, 32, 4);
      Control := New(PInputLine, Init(R, 80));
      Control^.HelpCtx := hcDFindText;
      Insert(Control);
      R.Assign(2, 2, 20, 3);
      Insert(New(PLabel, Init(R, '~S~earch Text', Control)));
      R.Assign(32, 3, 35, 4);
      Insert(New(PHistory, Init(R, PInputLine(Control), 10)));

      R.Assign(3, 5, 35, 7);
      Control := New(PCheckBoxes, Init(R,
        NewSItem('~C~ase Sensitive',
        NewSItem('~W~hole Words Only', nil))));
      Control^.HelpCtx := hcCCaseSensitive;
      Insert(Control);

      R.Assign(14, 9, 24, 11);
      Control := New(PButton, Init(R, slOK, cmOk, bfDefault));
      Control^.HelpCtx := hcDOk;
      Insert(Control);

      Inc(R.A.X, 12);
      Inc(R.B.X, 12);
      Control := New(PButton, Init(R, slCancel, cmCancel, bfNormal));
      Control^.HelpCtx := hcDCancel;
      Insert(Control);

      SelectNext(False);
    end;
    Result := D;
  end;

  function DECreateReplaceDialog: PDialog;
  var
    Dialog: PDialog;
    Control: PView;
    R: TRect;
  begin
    R.Assign(0, 0, 40, 16);
    Dialog := New(PDialog, Init(R, 'Replace'));
    with Dialog^ do begin
      Options := Options or ofCentered;

      R.Assign(3, 3, 34, 4);
      Control := New(PInputLine, Init(R, 80));
      Control^.HelpCtx := hcDFindText;
      Insert(Control);
      R.Assign(2, 2, 20, 3);
      Insert(New(PLabel, Init(R, '~S~earch Text', Control)));
      R.Assign(34, 3, 37, 4);
      Insert(New(PHistory, Init(R, PInputLine(Control), 10)));

      R.Assign(3, 6, 34, 7);
      Control := New(PInputLine, Init(R, 80));
      Control^.HelpCtx := hcDReplaceText;
      Insert(Control);
      R.Assign(2, 5, 20, 6);
      Insert(New(PLabel, Init(R, 'New ~T~ext', Control)));
      R.Assign(34, 6, 37, 7);
      Insert(New(PHistory, Init(R, PInputLine(Control), 11)));

      R.Assign(3, 8, 37, 12);
      Control := New(Dialogs.PCheckBoxes, Init(R,
        NewSItem('~C~ase Sensitive',
        NewSItem('~W~hole Words Only',
        NewSItem('~R~egular Expressions',
        NewSItem('~R~eplace All', nil))))));
      Control^.HelpCtx := hcCCaseSensitive;
      Insert(Control);

      R.Assign(8, 13, 18, 15);
      Control := New(PButton, Init(R, '~O~k', cmOk, bfDefault));
      Control^.HelpCtx := hcDOk;
      Insert(Control);

      R.Assign(22, 13, 32, 15);
      Control := New(PButton, Init(R, 'Ca~n~cel', cmCancel, bfNormal));
      Control^.HelpCtx := hcDCancel;
      Insert(Control);

      SelectNext(False);
    end;
    Result := Dialog;
  end;

  function MyStdEditorDialog(Dialog: Int16; Info: Pointer): word;
  begin
    case Dialog of
      edSaveAs: begin                           // New dialog in English.
        Result := MyApp.ExecuteDialog(New(PFileDialog, Init('*.txt',
          'Save File As', '~F~ile Name', fdOkButton, 101)), Info);
      end;
      edFind: begin                             // The completely new Find dialog.
        Result := Application^.ExecuteDialog(DECreateFindDialog, Info);
      end;
      edReplace: begin                          // The completely new Replace dialog.
        Result := MyApp.ExecuteDialog(DECreateReplaceDialog, Info);
      end;
      else begin
        Result := StdEditorDialog(Dialog, Info);
      end;                                      // Call original dialogs.
    end;
  end;

  constructor TMyApp.Init;
  begin
    inherited Init;
    EditorDialog := @MyStdEditorDialog; // The new dialog routine.
    DisableCommands([cmSave, cmSaveAs, cmCut, cmCopy, cmPaste, cmClear, cmUndo]);
    NewWindows('', False);              // Create empty window.

    ClipWindow := NewWindows('', True);
    if ClipWindow <> nil then begin
      Clipboard := ClipWindow^.Editor;
      Clipboard^.CanUndo := False;
    end;
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F2~ Save', kbF2, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil)))), nil)));
  end;

(*
New Edit functions have been added to the menu.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~N~ew', 'F4', kbF4, cmNewWin, hcNoContext,
        NewItem('~O~pen...', 'F3', kbF3, cmOpen, hcNoContext,
        NewItem('~S~ave', 'F2', kbF2, cmSave, hcNoContext,
        NewItem('Save ~A~s...', '', kbNoKey, cmSaveAs, hcNoContext,
        NewItem('Save ~A~ll', '', kbNoKey, cmSaveAll, hcNoContext,
        NewLine(
        NewItem('~E~xit', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))))),
      NewSubMenu('~E~dit', hcNoContext, NewMenu(
        NewItem('~U~ndo', '', kbAltBack, cmUndo, hcUndo,
        NewLine(
        NewItem('Cu~t~', 'Shift+Del', kbShiftDel, cmCut, hcCut,
        NewItem('~C~opy', 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
        NewItem('~P~aste', 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
        NewItem('~D~elete', 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,
        NewLine(
        NewItem('~C~lipboard', '', kbNoKey, cmShowClip, hcCut, nil))))))))),
      NewSubMenu('~S~earch', hcNoContext, NewMenu(
        NewItem('~F~ind...', 'Ctrl+F', kbCtrlF, cmFind, hcNoContext,
        NewItem('~R~eplace...', 'Ctrl+H', kbCtrlH, cmReplace, hcNoContext,
        NewItem('Find ~N~ext', 'Ctrl+N', kbCtrlN, cmSearchAgain, hcNoContext, nil)))),
      NewSubMenu('~W~indow', hcNoContext, NewMenu(
        NewItem('~T~ile', '', kbNoKey, cmTile, hcNoContext,
        NewItem('~C~ascade', '', kbNoKey, cmCascade, hcNoContext,
        NewItem('Close ~A~ll', '', kbNoKey, cmCloseAll, hcNoContext,
        NewItem('~R~efresh', '', kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem('~S~ize/Move', 'Ctrl+F5', kbCtrlF5, cmResize, hcNoContext,
        NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcNoContext,
        NewItem('~N~ext', 'F6', kbF6, cmNext, hcNoContext,
        NewItem('~P~revious', 'Shift+F6', kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem('~C~lose', 'Alt+F3', kbAltF3, cmClose, hcNoContext, nil)))))))))))), nil)))))));
  end;
  //code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Not enough memory!', nil, mfError + mfOkButton);
  end;

(*
Here you can see how to create a hidden window.
*)
//code+
  function TMyApp.NewWindows(FileName: ShortString; Visible: Boolean) : PEditWindow;
  var
    Win: PEditWindow;
    R: TRect;
  const
    WinCounter: integer = 0;
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PEditWindow, Init(R, FileName, WinCounter));
    if ValidView(Win) <> nil then begin
      if Visible then begin
        win^.Hide;        // Hide window.
      end;
      Result := PEditWindow(MyApp.InsertWindow(win));
    end else begin
      Dec(WinCounter);
    end;
  end;
//code-

  procedure TMyApp.OpenWindows;
  var
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    FileName := '*.*';
    New(FileDialog, Init(FileName, 'Open File', '~F~ilename', fdOpenButton, 1));
    if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
      NewWindows(FileName, False);
    end;
  end;

  procedure TMyApp.SaveAll;

    procedure SendSave(P: PView);
    begin
      Message(P, evCommand, cmSave, nil);
    end;

  begin
    Desktop^.ForEach(@SendSave);
  end;

  procedure TMyApp.CloseAll;

    procedure SendClose(P: PView);
    begin
      Message(P, evCommand, cmClose, nil);
    end;

  begin
    Desktop^.ForEach(@SendClose);
  end;

(*
Here you can see how to make the hidden clipboard window visible.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows('', False);
        end;
        cmOpen: begin
          OpenWindows;
        end;
        cmSaveAll: begin
          SaveAll;
        end;
        cmCloseAll: begin
          CloseAll;
        end;
        cmRefresh: begin
          ReDraw;
        end;
        cmShowClip: begin     // Show clipboard.
          ClipWindow^.Select;
          ClipWindow^.Show;
        end;
        else begin
          Exit;
        end;
      end;
    end;
  end;
//code-

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Run
  MyApp.Done;   // Free resources
end.
