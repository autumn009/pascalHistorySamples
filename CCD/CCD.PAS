
{$Ia:\lib\paslib\regdef.pl}
{$Ia:\lib\paslib\mserr.pl}
{$Ia:\lib\paslib\schdir.pl}
{$Ia:\lib\paslib\trmesc.plb}


var now_ptr:integer;
    exit_f:boolean;

procedure NothingError;
  begin
    set_text_color(text_white);
    writeln('No Directory File');
    halt;
  end{procedure NothingError};

procedure set_inv(y:integer);
  begin
    gotoxy(1,y+1);
    set_text_color(text_cyan_invert);
    writeln(find_file_name_list[y]);
  end{procedure set_inv};

procedure set_nrm(y:integer);
  begin
    gotoxy(1,y+1);
    set_text_color(text_cyan);
    writeln(find_file_name_list[y]);
  end{procedure set_inv};



procedure incptr;
  begin
    if now_ptr<lists then begin
      set_nrm(now_ptr);
      now_ptr:=now_ptr+1;
      set_inv(now_ptr);
    end{if};
  end{procedure incptr};

procedure decptr;
  begin
    if now_ptr>1 then begin
      set_nrm(now_ptr);
      now_ptr:=now_ptr-1;
      set_inv(now_ptr);
    end{if};
  end{procedure decptr};

procedure do_chdir;
  begin
    chdir(find_file_name_list[now_ptr]);
  end{do_chdir};


procedure onscreen;
  var path:pathstr;
      i:integer;
      ch:char;
  begin
    clrscr;
    set_text_color(text_white);
    write('CCD V1.0/SP=inc,BS=dec,CR=cd,ESC=exit');
    set_text_color(text_yellow);
    write(' Now Dir=');
    set_text_color(text_green);
    getdir(0,path);
    writeln(path);
    gen_list(16,'*.*');
    if errorcode<>18 then ms_fatal_error(errorcode);
       {if list_over_f then}
    if lists=0 then NothingError;
    set_text_color(text_cyan);
    for i:=1 to lists do begin
      writeln(find_file_name_list[i]);
    end{for i};
  {screen menu select};
    now_ptr:=1;
    set_inv(now_ptr);
    exit_f:=false;
    repeat
      gotoxy(1,1);
      read(kbd,ch);
      case ch of
        ' ',#10 : incptr;
        #8,#11  : decptr;
        #13     : begin do_chdir;onscreen end;
        #27     : exit_f:=true;
      end{case};
    until exit_f;
  end{procedure onscreen};

var path:pathstr;
begin

    onscreen;

{End Process}
    clrscr;
    getdir(0,path);
    gotoxy(1,22);
    set_text_color(text_white);
    writeln('Now Working Dir=',path);
end.
