var mqtt = require('mqtt');

//BaseURL of our microservice database
export const config={
    baseLink:'http://localhost:9090',
}

//Function permitting to return actual date, used when receiving message
export function returnDate() {
    var today = new Date();
    var ss = String(today.getSeconds()).padStart(2, '0');
    var mm = String(today.getMinutes()).padStart(2, '0');
    var hh = String(today.getHours()).padStart(2, '0');
    var dd = String(today.getDate()).padStart(2, '0');
    var MM = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();

    today = dd + '/' + MM + '/' + yyyy + '-' + hh + ':' + mm + ':' + ss;
    return today;
}


export function nbChar(chaine,lettre) {
    return chaine.match(new RegExp(lettre,"gi")).length;
}

var clientMqtt = null;

//Permits to connect the user
export function connectMQTT(host,username,password,port,callback,errorCallback){
    var config = {
        host: host,
        username: username,
        password: password,
        port: port,
        connectTimeout: 1000
    }

    clientMqtt = mqtt.connect(config);

    clientMqtt.on('connect',(e)=>{
        callback();
    })


    clientMqtt.on('offline',(e)=>{
        errorCallback();
    })
}

//Permits to get message
export function getMessage(callback){
    if(clientMqtt!=null)
    {
        clientMqtt.on('message', (topic, message, options) => {
            // message is Buffer
            callback(topic,message,options);
        })
    }
    else{
        console.log('client null');
    }
}

//Permits to publish a message on a topic
export function publishMQTT(topic,messageToSend,options){
    clientMqtt.publish(topic,messageToSend,options);
}

export function subscribeMQTT(topicToSubscribe){
    clientMqtt.subscribe(topicToSubscribe, function (err) {
        if (err) {
            console.log('Error:' + err);
        }
    })
}

export function unsubscribeMQTT(topicToUnSubscribe){
    clientMqtt.unsubscribe(topicToUnSubscribe, function (err) {
        if (err) {
            console.log('Error:' + err);
        }
    })
}

//Permits to associate a color for a string
export function stringToRGB(str){
    var hash = 0;
    for (var i = 0; i < str.length; i++) {
        hash = str.charCodeAt(i) + ((hash << 5) - hash);
    }
    var colour = '#';
    for (var i = 0; i < 3; i++) {
        var value = (hash >> (i * 8)) & 0xFF;
        colour += ('00' + value.toString(16)).substr(-2);
    }
    return colour;
}

//Check if elements like token are not null
export function isNotNull(toCheck){
    if(toCheck != null && toCheck != "" && toCheck != "undefined" && toCheck != "-1"){
        return true;
    }else{
        return false;
    }
}
