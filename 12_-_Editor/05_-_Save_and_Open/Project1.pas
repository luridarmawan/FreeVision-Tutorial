//image image.png
(*
An editor only becomes useful when file functions are added, such as opening and saving.
Opening is similar to creating an empty window.
The only difference is that you provide a filename, which is obtained via a FileDialog.
For simple saving, you don't need to do much. You just need to call the <b>cmSave</b> event, e.g. via the menu.
*)
//lineal
program Project1;

uses
  App,
  Objects,
  Drivers,
  Views,
  MsgBox,
  Editors,
  Dialogs,
  StdDlg,
  Menus;

const
  cmNewWin = 1001;
  cmRefresh = 1002;
type

(*
OpenWindows and SaveAll have been added here.
*)
//code+
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;

    procedure NewWindows(FileName: ShortString);
    procedure OpenWindows;
    procedure SaveAll;
    procedure CloseAll;
  end;
//code-

(*
The <b>Save as</b> dialog is already built-in, but unfortunately in English.
Therefore this function is redirected to a custom routine.
I have also replaced the mask <b>*.*</b> with <b>*.txt</b>.
For the remaining dialogs, the original routines are used, this is done with <b>StdEditorDialog(...)</b>.
The declaration of <b>MyApp</b> is already here at the top, because it is needed here.

In MyApp.Init, the new standard dialogs are also assigned.
*)
//code+
var
  MyApp: TMyApp;

  function MyStdEditorDialog(Dialog: Int16; Info: Pointer): Word;
  begin
    case Dialog of
      edSaveAs: begin                 // Custom save dialog.
        MyStdEditorDialog := MyApp.ExecuteDialog(New(PFileDialog, Init('*.txt', 'Save file as', '~F~ilename', fdOkButton, 101)), Info);
      end;
    else
      StdEditorDialog(Dialog, Info);  // Call original dialogs.
    end;
  end;

  constructor TMyApp.Init;
  begin
    inherited Init;
    EditorDialog := @MyStdEditorDialog; // The new dialog routine.
    DisableCommands([cmSave, cmSaveAs, cmCut, cmCopy, cmPaste, cmClear, cmUndo]);
    NewWindows('');                     // Create empty window.
  end;
//code-

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F2~ Save', kbF2, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil)))), nil)));
  end;

(*
The new file functions have been added to the menu.
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
        NewItem('Save ~a~s...', '', kbNoKey, cmSaveAs, hcNoContext,
        NewItem('Save ~a~ll', '', kbNoKey, cmSaveAll, hcNoContext,
        NewLine(
        NewItem('~E~xit', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))))),
      NewSubMenu('~W~indow', hcNoContext, NewMenu(
        NewItem('~T~ile', '', kbNoKey, cmTile, hcNoContext,
        NewItem('~C~ascade', '', kbNoKey, cmCascade, hcNoContext,
        NewItem('~C~lose all', '', kbNoKey, cmCloseAll, hcNoContext,
        NewItem('~R~efresh', '', kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem('~S~ize/~M~ove', 'Ctrl+F5', kbCtrlF5, cmResize, hcNoContext,
        NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcNoContext,
        NewItem('~N~ext', 'F6', kbF6, cmNext, hcNoContext,
        NewItem('~P~revious', 'Shift+F6', kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem('~C~lose', 'Alt+F3', kbAltF3, cmClose, hcNoContext, Nil)))))))))))), nil)))));

  end;
//code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Not enough memory !', nil, mfError + mfOkButton);
  end;

(*
Insert an editor window.
If the filename is '', a simple empty window is created.
*)
//code+
  procedure TMyApp.NewWindows(FileName: ShortString);
  var
    Win: PEditWindow;
    R: TRect;
  const
    WinCounter: integer = 0;      // Window counter
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PEditWindow, Init(R, FileName, WinCounter));

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin                // Insert the window.
      Dec(WinCounter);
    end;
  end;
//code-
(*
Open a file and load it into an edit window.
A <b>FileDialog</b> is called in which you can select a file.
You don't need to worry about loading the file into the editor window, this is done automatically.
*)
//code+
  procedure TMyApp.OpenWindows;
  var
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    FileName := '*.*';
    New(FileDialog, Init(FileName, 'Open file', '~F~ilename', fdOpenButton, 1));
    if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
      NewWindows(FileName); // New window with selected file.
    end;
  end;
//code-
(*
Save all files, done almost the same way as closing all.
*)
//code+
  procedure TMyApp.SaveAll;

    procedure SendSave(P: PView);
    begin
      Message(P, evCommand, cmSave, nil); // Send save command.
    end;

  begin
    Desktop^.ForEach(@SendSave);          // Apply to all windows.
  end;
//code-

  procedure TMyApp.CloseAll;

    procedure SendClose(P: PView);
    begin
      Message(P, evCommand, cmClose, nil);
    end;

  begin
    Desktop^.ForEach(@SendClose);
  end;

(*
Catch and process the various events.
You don't need to handle <b>cmSave</b> and <b>cmSaveAs</b>, <b>PEditWindow</b> does this automatically for you.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows('');   // Create empty window.
        end;
        cmOpen: begin
          OpenWindows;      // Open file.
        end;
        cmSaveAll: begin
          SaveAll;          // Save all.
        end;
        cmCloseAll:begin
          CloseAll;         // Closes all windows.
        end;
        cmRefresh: begin
          ReDraw;           // Redraw application.
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
  MyApp.Done;   // Release
end.
