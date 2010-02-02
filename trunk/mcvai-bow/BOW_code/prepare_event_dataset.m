
    fid=fopen('/home/joost/images/event_dataset/classes.txt','r');
        image_counter=0;
    while(~feof(fid))          
        class_name=sprintf('%s',fgetl(fid));
        display(class_name);
        
        fid2=fopen(sprintf('/home/joost/images/event_dataset/%s09.txt',class_name),'r');

        while(~feof(fid2))          
            image_counter=image_counter+1;
            image_name=sprintf('%s',fgetl(fid2));
            im=imread(sprintf('/home/joost/images/event_dataset/%s/%s',class_name,image_name));
%            im=double(im);
            
            if(size(im,1)>size(im,2))
                img=imresize(im,300/size(im,1),'bilinear');
            else
                img=imresize(im,300/size(im,2),'bilinear');
            end
            imwrite(img,sprintf('/home/joost/images/event_dataset/events2009/event_%s.jpg',num2string(image_counter,3)),'jpg','Quality',100);
            display(image_name);
                        
            
        end
        fclose(fid2);
    end
    fclose(fid)
    
    return;
    
    fid2=fopen(sprintf('/home/joost/images/event_dataset/events2009/images.txt',class_name),'r');
    counter=0;
     while(~feof(fid2))          
            counter=counter+1
            
            im=double(imread( fgetl(fid2) ));
            B=im(:,:,1)+im(:,:,2);
            
%            image_names{counter}=sprintf('%s',fgetl(fid2));
     end 
     fclose(fid2);