(*

  "HEXBIN.COM" ヘキサファイルからバイナリーファイルを作る
         1987,Apr by Aki

  コマンドの書式：
       HEXBIN 入力ファイル名　出力ファイル名

*)

type str2=string[2];

var infile:text;
    outfile:file of byte;
    sname,dname:string[100];



function hexnum1(s:char):byte;
  begin
    case s of
      '0'..'9' : hexnum1:=ord(s)-ord('0');
      'A'..'F' : hexnum1:=ord(s)-ord('A')+10;
    end{case};
  end{function hexnum1};


function hexnum(s:str2):byte;
  begin
    hexnum:=hexnum1(copy(s,1,1))*16
           +hexnum1(copy(s,2,1));
  end;

procedure hexbin;
  var endf:boolean;
      aline:string[255];
      leng,i:integer;
      j:byte;
  begin
    endf:=false;
    repeat
      readln(infile,aline);
      leng:=hexnum(copy(aline,2,2));
      if leng=0 then endf:=true
      else begin
        for i:=1 to leng do begin
          j:=hexnum(copy(aline,8+i*2,2));
          write(outfile,j);
        end{for};
      end{if};
    until endf=true;
  end{hexbin};


begin{main}
  writeln('ＨＥＸＢＩＮ　Ｖｅｒ１．０  1987,Apr by Aki');
  if ParamCount<>2 then begin write('パラメータの数が異常です');halt end;
  sname:=ParamStr(1);
  dname:=ParamStr(2);
  assign(infile,sname+'.HEX');
  assign(outfile,dname);
  reset(infile);
  rewrite(outfile);

  hexbin;

  close(infile);
  close(outfile);
  writeln('Completed');
end{main}.
