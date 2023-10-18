function [info,tdir,tfile] = snoop(path, all, filetype, saveinfo, fid)

%# function [info,tdir,tfile]=snoop(path, all, filetype, saveinfo, fid)
%#
%#  by Annika 6.9.2002
%#
%# path     = path to be examined
%# all      = all file types or files with specific extension
%#            1 == all files
%#            0 == files with specific extension (filetype)
%# filetype = specified file extensions of files to be listed 
%# saveinfo = just list the information or save it to file <filename>
%#            1 == save
%#            0 == just list to screen
%# filename = name of the file where the filelist of <path> is to be saved
%# fid      = file identifier of the savefile <filename>
%#
%# info     = struct with information of files and directories in <path>
%# tdir     = number of directories directly under <path>
%# tfile    = number of files

eval(['cd ' path ]);
tmp = dir;
[n,m] = size(tmp);
%# total number of interest is n-2 (1 and 2 are . and ..)

tdir = 1;
tfile = 1;

for i = 3:n,
  if tmp(i).isdir==1,
    info(tdir).dir = tmp(i).name;
    tdir = tdir+1;
  else
    info(tfile).file = (tmp(i).name);
    tfile = tfile+1;
  end
end

if saveinfo == 0
  switch all
   case 1
    fprintf('\nContents of %s \n',path);
      fprintf('\n directories: \n');
      for j = 1:tdir-1,
	fprintf('  %s \n',info(j).dir);
      end
      fprintf('\n files:\n');
      for j = 1:tfile-1,
	fprintf('  %s \n',info(j).file);
      end
   case 0
    switch filetype
     case 'mat' %# mat-files
      W = what;
      names1 = W.mat; %# cell array
      [n,m] = size(names1);
      if n==0 return
      else
	names2 = cell2struct(names1,'mat',n);
	for ii = 1:n,
	  info(ii).mat = names2(ii).mat;
	end
	fprintf('\n mat-files in %s \n',path)
	for iik = 1:n,
	  fprintf('  %s \n',info(iik).mat);
	end
      end
     case 'm' %# m-files
      W = what;
      names1 = W.m; %# cell array
      [n,m] = size(names1);
      if n == 0 return
      else
	names2 = cell2struct(names1,'m',n) ;
	for ii = 1:n,
	  info(ii).m = names2(ii).m;
	end
	fprintf('\n m-files in %s \n',path)
	for iik = 1:n,
	  fprintf('  %s \n',info(iik).m);
	end
      end
     otherwise
      match = [];
      str = ['.' filetype];
      for j = 1:tfile-1
	if (isempty(findstr(info(j).file, str)) == 0)
	  match = [match j]; %# oikeiden indeksit info.file:ssä
	end
      end
      fprintf('\n %s-files in %s \n',filetype,path);
      for j = 1:length(match)
	fprintf('  %s \n',info(match(j)).file);
      end
    end
  end
elseif (saveinfo == 1)
  switch all
   case 1
    fprintf(fid,'\nContents of %s \n',path);
    fprintf(fid,'\n directories: \n');
    for j = 1:tdir-1,
      fprintf(fid,'%s \n',info(j).dir);
    end
    fprintf(fid,'\n files:\n');
    for j = 1:tfile-1,
      fprintf(fid,'%s \n',info(j).file);
    end
    
   case 0
    switch filetype
     case 'mat' %# mat-files
      W = what;
      names1 = W.mat; %# cell array
      [n,m]  =  size(names1);
      if (n==0) 
	return
      else
	names2 = cell2struct(names1,'mat',n);
	for ii = 1:n,
	  info(ii).mat = names2(ii).mat;
	end
	fprintf(fid,'mat-files in %s \n',path);
	fprintf(fid,'-------------------------\n');
	for iik = 1:n,
	  fprintf(fid,' %s \n',info(iik).mat);
	end
      end
     case 'm' %# m-files
      W = what;
      names1 = W.m; %# cell array
      [n,m] = size(names1);
      if n==0 return
      else
	names2 = cell2struct(names1,'m',n) ;
	for ii = 1:n,
	  info(ii).m = names2(ii).m;
	end
	fprintf(fid,'m-files in %s \n',path);
	fprintf(fid,'-------------------------\n');
	for iik = 1:n,
	  fprintf(fid,' %s \n',info(iik).m);
	end
      end
     otherwise
      match = [];
      str = ['.' filetype];
      for j = 1:tfile-1
	if (isempty(findstr(info(j).file, str)) == 0)
	  match = [match j]; %# oikeiden indeksit info.file:ssä
	end
      end
      if (length(match)>0)
	fprintf(fid,'%s-files in %s \n',filetype,path);
	fprintf(fid,'----------------------------\n');
	for j = 1:length(match)
	  fprintf(fid,' %s \n',info(match(j)).file);
	end
      end
    end
  end
end

tdir = tdir - 1;
tfile = tfile - 1;