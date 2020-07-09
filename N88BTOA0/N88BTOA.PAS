{ N88BtoA

}

type idname=string[20];

const bsize=$7000;

      functions:array[$80..$CF] of idname=
('DATE$','MID$','POINT','PEN','TIME$','VIEW','WINDOW','','','','','','','','',
'','ABS','ATN','ASC','ATTR$','CSRLIN','CINT','CSNG','CDBL','CVI','CVS','CVD',
'COS','CHR$','DSKF','ERL','ERR','EXP','EOF','FIX','FPOS','HEX$','INSTR','INT',
'INP','INKEY$','LPOS','LOG','LOC','LEN','LEFT$','LOF','MKI$','MKS$','MKD$',
'MAP','OCT$','POS','PEEK','RIGHT$','RND','SEARCH','SGN','SQR','SIN','STR$',
'STRING$','SPACE$','TAN','VAL','DSKI$','FRE','VARPTR','INPUT$','JIS$','KNJ$',
'KTYPE','KLEN','KMID$','KEXT$','KINSTR','AKCNV$','KACNV$','','');

       statements:array[$80..$FF] of idname=
('AUTO','BSAVE','BLOAD','BEEP','CONSOLE','COPY','CLOSE','CONT','CLEAR',
'CALL','COMMON','CHAIN','COM','CIRCLE','COLOR','CLS','DELETE','DATA',
'DIM','DEFSTR','DEFINT','DEFSNG','DEFDBL','DSKO$','DEF','ELSE','END',
'ERASE','EDIT','ERROR','FOR','FIELD','FILES','FN','DRAW','GOTO','GO TO',
'GOSUB','GET','HELP','INPUT','IF','KEY','KILL','KANJI','LOCATE','LPRINT',
'LLIST','LET','LINE','LOAD','LSET','LFILES','MOTOR','MERGE','MON','NEXT',
'NAME','NEW','NOT','OPEN','OUT','ON','OPTION','OFF','PRINT','PUT','POKE',
'PSET','PRESET','PAINT','RETURN','READ','RUN','RESTORE','','RESUME','RSET',
'RENUM','RANDOMIZE','ROLL','SCREEN','STOP','SWAP','SAVE','SPC','STEP','THEN',
'TRON','TROFF','TAB','TO','TERM','USING','USR','WIDTH','WAIT','WHILE',
'WEND','WRITE','LIST','SEG','SET','KINPUT','SRQ','CMD','IRESET','ISET',
'POLL','RBYTE','WBYTE','KPLOAD','','>','=','<','+','-','*','/','^',
'AND','OR','XOR','EQV','IMP','MOD','\');






var basinput:file;
    ascoutput:text;
    bb:array[1..bsize]of byte;
    inputname,outputname:string[100];
    ptr:integer;

procedure spaces(x:byte);
 var i:byte;
 begin
   for i:=1 to x do write(ascoutput,' ');
   ptr:=ptr+1;
 end;


procedure intlang(x:byte);
 begin
   write(ascoutput,' ',statements[x],' ');
   ptr:=ptr+1;
 end;

procedure intlangFF;
 begin
   write(ascoutput,' ',functions[bb[ptr+1]],' ');
   ptr:=ptr+2;
 end;


procedure onetoken;
 var x:byte;
  begin
   x:=bb[ptr];
   if x=0 then begin ptr:=ptr+1 end
   else if x<$0a then spaces(x)
   else if x<$0b then spaces(1)

   else if x=$FF then intlangFF
   else if x>=$80 then intlang(x)
   else ptr:=ptr+1
  end;

procedure oneline;
var linelength:integer;
    linenumber:real;
    nextptr:integer;
begin
  linelength:=bb[ptr+0]+bb[ptr+1]*256;
  linenumber:=bb[ptr+2]+bb[ptr+3]*256;
  nextptr:=ptr+linelength;
  write(ascoutput,linenumber:5:0);
  write(ascoutput,' ');
  ptr:=ptr+4;
  repeat
    onetoken
  until ptr>=nextptr;
  writeln(ascoutput);

end;



procedure oneprog;
var eoff:boolean;
begin
eoff:=false;
while eoff=false do
 begin
   if (bb[ptr+2]=0)and(bb[ptr+3]=0)
     then
        begin
           writeln('End of Prog.');
           eoff:=true;
        end
     else
        begin
           oneline;
        end;
 end;
end;



procedure main;
 var ans:char;
     answer:integer;
 begin
  writeln('Binary Saved N88BASIC(86) Program Convert to ASCII file');
  write  ('Enter Input BASIC Prog. FILE NAME?');
  readln(inputname);
  writeln('');
  write  ('Enter Output ASCII FILE NAME?');
  readln(outputname);
  writeln('');
  assign(basinput,inputname);
  assign(ascoutput,outputname);
  reset(basinput);
  rewrite(ascoutput);
  blockread(basinput,bb,bsize div 128,answer);
  ptr:=1;
  if bb[1]=$fe then
       begin
           write('Is this file saved by MS-DOS Version N88BASIC ?(y/n)');
           read(ans);
           if (ans='y')or(ans='Y') then ptr:=2;
       end;
  if ptr=2
      then writeln('Prog. file was Saved by MS-DOS Version N88BASIC')
      else writeln('Prog. file was Saved by Standalone N88BASIC');

  oneprog;

  close(basinput);
  close(ascoutput);
 end;

begin
 main;
end.
