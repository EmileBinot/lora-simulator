classdef pbNotify
    %pbNotify sends a push notification to users.
    %   To use this class you will need to signup for a Push Bullet account. See: https://www.pushbullet.com/
    %   
    %   pbO = pbNotify(<accessToken>)
    %   Once you signed up for an account, you will need your access token to create a pbNotifier object. https://www.pushbullet.com/account
    %   
    %   ret = pbO.notify(<Message>)
    %   This shall push the message to the devices registered in your account and return a json string.
    
    
    properties
        accessToken='';
        computer='';
    end
    
    methods
        function o=pbNotify(token)
            o.accessToken=token;
            if ispc
                o.computer = getenv('COMPUTERNAME');
            else      
                o.computer = getenv('HOSTNAME');      
            end
        end
        function r=notify(o,message)
            headers(1).name= 'Access-Token';
            headers(1).value= o.accessToken;
            headers(2).name= 'Content-Type';
            headers(2).value= 'application/json';
            
            data=['{"body":"',message,'","title":"',o.computer,...
                '","type":"note"}'];
            r= urlread2('https://api.pushbullet.com/v2/pushes',...
                        'Post',data, headers);            
        end
    end
    
end