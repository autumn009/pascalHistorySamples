
const lvl=8;

{ HARD WARE CONTROL }
procedure set_16color_mode;
  begin
    port[$6A]:=$00+1;
  end;


procedure palet(col1,Blvl,Rlvl,Glvl:integer);
  var dummy:integer;
  begin
    port[$A8]:=col1;
    dummy:=dummy;
    port[$AA]:=Glvl;
    port[$AC]:=Rlvl;
    port[$AE]:=Blvl;
  end;

var i,l:integer;

begin{main}
   set_16color_mode;
   for i:=0 to 7 do begin
      l:=i*2;
      palet(i,l,l,l);
   end{for};
   for i:=8 to 15 do begin
      palet(i,0,0,0);
   end{for};
end{main}.
