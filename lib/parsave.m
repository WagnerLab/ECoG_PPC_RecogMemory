function parsave(fname, data, datastr,opts)
% inputs:
% fname is the fullpath filename
% data is the variable to save
% datastr is the name of the variable to save
% opts are options for saving

eval([datastr '= data;'])
save(fname, datastr, opts)

end