# 02 - Status Line and Menu
## 15 - Menu Extended

![image.png](image.png)

Adding multiple menu items.
Here it is split up for the sake of clarity.

---
For own commands, you still need to define command codes.
It is recommended to use values > 1000, so that there are no overlaps with the standard codes.

```pascal
const
  cmList = 1002;      // File List
  cmAbout = 1001;     // Show About
```

For a menu you have to inherit **InitMenuBar**.

```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Status line
    procedure InitMenuBar; virtual;      // Menu
  end;
```

You can also split the menu entries via pointers.
Whether you nest or split it is a matter of taste.
You can insert a blank line with **NewLine**.
It is recommended to write **...** behind the designation when a dialog opens for a menu item.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rectangle for the menu line position.

    M: PMenu;                          // Whole menu
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M1_0: PMenuItem; // Simple menu items

  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M1_0), nil);

    M0_2 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_1 := NewLine(M0_2);
    M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(R, M));
  end;
```
