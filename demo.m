path = 'C:\Users\dnhth\Desktop\code';
Inputs=dir(strcat(path,'\dataset\*.jpg'));
Masks=dir(strcat(path,'\mask\*.png'));

psnrs = zeros(20,1);
ssims = zeros(20, 1);
fnames = strings(20, 1);
i=1;

for l=1:length(Masks)
    for k=1:length(Inputs)
       infiles = strsplit(Inputs(k).name,'.');
       mafiles = strsplit(Masks(l).name,'.');
       ifname = infiles{1};
       mfname = mafiles{1};
       
       Input = imread(strcat(path,'\dataset\', Inputs(k).name));
       Mask = imread(strcat(path,'\mask\',Masks(l).name));
       
       Mask(Mask==0)=0;
       Mask(Mask~=0)=1;

       Input2 = Input;
       Input2(Mask~=0)=255;
       awmf = uint8(inpaintingtrimmed(Input2, Mask));
       
       imwrite(awmf, strcat(path, '\proposed\', mfname, '_', ifname, '.jpg'));
       psnrs(i)=psnr(awmf, Input);
       ssims(i)=ssim(awmf, Input);
       fnames(i)=strcat(mfname,'_',ifname);
       i=i+1;
    end
end
exporter =[fnames psnrs ssims];
xlswrite(strcat(path,'\proposed\proposed.xlsx'),exporter);