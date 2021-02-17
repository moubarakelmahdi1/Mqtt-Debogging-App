<template>
    <v-flex>
        <!--Publish panel permitting to send a message to a certain topic-->
        <v-flex>
            <v-expansion-panel v-model="showPublishPanel">
                <v-expansion-panel-content>
                    <template v-slot:header>
                        <div class="strongTexts">Publish</div>
                    </template>

                    <v-form @submit.prevent>
                        <v-layout>
                            <v-flex md10 offset-md1 offset-xs1>

                                </br>

                                <v-text-field
                                        v-model="publishTopic"
                                        label="Topic"
                                        box>
                                </v-text-field>

                                </br>

                                <v-textarea
                                        v-model="message"
                                        label="Message"
                                        box
                                ></v-textarea>
                            </v-flex>
                        </v-layout>

                        <!--<v-flex d-flex>
                            <v-flex md2 offset-md5>
                                <v-select

                                        v-model="retain"
                                        :items="retainChoice"
                                        label="Retained">

                                </v-select>
                            </v-flex>
                        </v-flex>-->


                        <!--Publish button who send the message to the topic choosed by the user-->
                        <v-flex>
                            <v-btn  type="submit"
                                    class="addButton"
                                   color=rgba(0,103,160,1)
                                   @click="publish()">
                                <div class="button">Publish</div>
                            </v-btn>
                        </v-flex>
                    </v-form>
                </v-expansion-panel-content>
            </v-expansion-panel>
        </v-flex>

        <!--PopUp permitting to change parameters to the message to send-->
        <v-dialog
                v-model="popUpMessage"
                width="500"
                persistent="">

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    Fill parameters for Message
                </v-card-title>

                </br>

                <v-form @submit.prevent>
                    <v-flex d-flex
                            v-for="index in parametersMap.size">
                        <v-flex md3 offset-md1 offset-xs1>
                            <div class="parameters">
                                {{parametersMap.keys()[index-1]}}
                            </div>
                        </v-flex>
                        <v-flex md8 d-flex>
                            <v-text-field
                                    ref="parameterContentMessage"
                                    @change="setValue('message',index,$event)"
                                    :value="findOldValue(index)"
                                    solo>
                            </v-text-field>
                            <div class="defaultValuebutton">
                                <v-tooltip top>
                                    <template v-slot:activator="{ on }">
                                        <v-btn fab small @click="setDefaultValue('message',index)" v-on="on">
                                            <v-icon dark>build</v-icon>
                                        </v-btn>
                                    </template>
                                    <span>{{defaultMap.values()[index-1]}}</span>
                                </v-tooltip>
                                <v-btn fab small v-if="findOldValue(index)!=''" @click="setOldValue('message',index)">
                                    <v-icon dark>backup</v-icon>
                                </v-btn>
                            </div>
                        </v-flex>
                    </v-flex>

                    <v-card-actions>
                        <v-btn
                                color="primary"
                                flat
                                @click="closePopUp('message')">
                            Cancel
                        </v-btn>

                        <v-spacer></v-spacer>

                        <v-btn  type="submit"
                                color="primary"
                                flat
                                @click="replaceText('message')">
                            Apply
                        </v-btn>
                    </v-card-actions>
                </v-form>

            </v-card>
        </v-dialog>

        <!--PopUp permitting to change parameters to the topic where we want to publish-->
        <v-dialog
                v-model="popUpTopic"
                width="500"
                persistent="">

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    Fill parameters for Topic
                </v-card-title>

                </br>

                <v-form @submit.prevent>
                    <v-flex d-flex
                            v-for="index in parametersMap.size">
                        <v-flex md3 offset-md1 offset-xs1>
                            <div class="parameters">
                                {{parametersMap.keys()[index-1]}}
                            </div>
                        </v-flex>
                        <v-flex md8 d-flex>
                            <v-text-field
                                    ref="parameterContentTopic"
                                    @change="setValue('topic',index,$event)"
                                    :value="findOldValue(index)"
                                    solo>
                            </v-text-field>
                            <div class="defaultValuebutton">
                                <v-tooltip top>
                                    <template v-slot:activator="{ on }">
                                        <v-btn fab small @click="setDefaultValue('topic',index)" v-on="on">
                                            <v-icon dark>build</v-icon>
                                        </v-btn>
                                    </template>
                                    <span>{{defaultMap.values()[index-1]}}</span>
                                </v-tooltip>
                                <v-btn fab small v-if="findOldValue(index)!=''" @click="setOldValue('topic',index)">
                                    <v-icon dark>backup</v-icon>
                                </v-btn>
                            </div>
                        </v-flex>
                    </v-flex>

                    <v-card-actions>
                        <v-btn
                                color="primary"
                                flat
                                @click="closePopUp('topic')">
                            Cancel
                        </v-btn>

                        <v-spacer></v-spacer>

                        <v-btn  type="submit"
                                color="primary"
                                flat
                                @click="replaceText('topic')">
                            Apply
                        </v-btn>
                    </v-card-actions>
                </v-form>
            </v-card>
        </v-dialog>
    </v-flex>
</template>

<script>
    const matchAll = require("match-all");
    import {publishMQTT} from '@/assets/js/Utils.js';
    var HashMap = require('hashmap');
    export default {
        name: 'PublishPanel',
        props: {
            'publishPanel': Number,
            'topic': String,
            'messageToSend': String,
            'actualTopic': String,
            'actualMessage': String,
            'demonstrations': Array,
            'selectedActionIndex': Number,
            'selectedDemoIndex': Number,
            'popUps' : Number,
            'oldValuesTab' : Array
        },
        data: function () {
            return {
                showPublishPanel: this.publishPanel,
                publishTopic: this.topic,
                message: this.messageToSend,
                popUpMessage: 0,
                popUpTopic: 0,
                parametersMap: new HashMap(),
                originalTopic: this.actualTopic,
                originalMessage: this.actualMessage,
                defaultMap: new HashMap(),
                content:'',
                showPopUps : this.popUps,
                oldValues : [{"key":"{{test}}","value":"{{test}}"}],
                retain: false,
                retainChoice:[true,false]
            }
        },
        watch: {
            publishTopic: function () {
                this.$emit('topic', this.publishTopic);
            },
            topic: function () {
                this.publishTopic = this.topic;
            },
            message: function () {
                this.$emit('messageToSend', this.message);
            },
            messageToSend: function () {
                this.message = this.messageToSend;
            },
            actualTopic: function () {
                this.originalTopic = this.actualTopic;
            },
            actualMessage: function () {
                this.originalMessage = this.actualMessage;
            },
            publishPanel: function () {
                this.showPublishPanel = this.publishPanel;
            },
            popUps:function(){
                this.showPopUps = this.popUps;
            },
            showPopUps:function(){
                this.$emit('popUps', this.showPopUps);
                if(this.showPopUps){
                    this.showPopUp('topic');
                }
            },
            oldValues:function(){
                this.$emit('oldValuesTab',this.oldValues);
            },
            oldValuesTab:function(){
                this.oldValues = this.oldValuesTab;
            }
        },
        methods: {
            publish() {
                if(this.publishTopic.length>0)
                {
                    var self = this;
                    var options = {
                        retain : self.retain,
                    };
                    publishMQTT(this.publishTopic, this.message , options);
                }
                else{
                    alert('Fill topic where to publish!');
                }
            },
            //Permits to show parameters popUp for the topic and the message we choosed
            showPopUp(type) {
                const regex = /{{([a-zA-Z0-9]*)}}/gm;
                let matches;
                if (type == 'topic') {
                    matches = matchAll(this.originalTopic, regex).toArray();
                } else if (type == 'message') {
                    matches = matchAll(this.originalMessage, regex).toArray();
                }
                for (var i=0; i < matches.length; i++) {
                    this.parametersMap.set('{{'+matches[i]+'}}', '{{'+matches[i]+'}}');
                    if(type=='topic')
                    {
                        this.defaultMap.set('{{'+matches[i]+'}}', this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].parametersTopics.filter(element => element.parameter == '{{'+matches[i]+'}}')[0].parameterDefaultValue);
                    }
                    else if(type=='message'){
                        this.defaultMap.set('{{'+matches[i]+'}}', this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].parametersMessages.filter(element => element.parameter =='{{'+matches[i]+'}}')[0].parameterDefaultValue);
                    }
                }
                if (this.parametersMap.size > 0) {
                    if (type == 'topic') {
                        this.publishTopic = this.originalTopic;
                        this.popUpTopic = 1;
                    } else if (type == 'message') {
                        this.message = this.originalMessage;
                        this.popUpMessage = 1;
                    }
                }
                else{
                    if(type=='topic'){
                        this.showPopUp('message');
                        this.showPopUps=0;
                    }

                }
            },
            //Permits to replace parameters
            replaceText(type) {
                for (var i = 0; i < this.parametersMap.size; i++) {
                    if (type == 'topic') {
                        this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].topic = this.publishTopic.replace(this.parametersMap.keys()[i], this.parametersMap.values()[i]);
                        this.publishTopic = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].topic;
                    } else if (type == 'message') {
                        this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].message = this.message.replace(this.parametersMap.keys()[i], this.parametersMap.values()[i]);
                        this.message = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].message;
                    }
                    var temp = new Object();
                    var res=1;
                    temp.key = this.parametersMap.keys()[i];
                    temp.value = this.parametersMap.values()[i];
                    for(var j=0;j<this.oldValues.length;j++){
                        if(this.oldValues[i].key==temp.key){
                            this.oldValues[i].value = this.parametersMap.values()[i];
                            res=0;
                        }
                    }
                    if(res){
                        this.oldValues.push(temp);
                    }
                }
                this.closePopUp();
                if(type=='topic'){
                    this.showPopUp('message');
                }
            },
            setDefaultValue(type,index) {
                this.parametersMap.set(this.parametersMap.keys()[index-1], this.defaultMap.values()[index-1]);
                if(type=='topic'){
                    this.$refs.parameterContentTopic[index-1].value=this.defaultMap.values()[index-1];
                }
                else if(type=='message')
                {
                    this.$refs.parameterContentMessage[index-1].value=this.defaultMap.values()[index-1];
                }
            },
            setValue(type,index,$event){
                this.parametersMap.set(this.parametersMap.keys()[index-1],$event);
                if(type=='topic'){
                    this.$refs.parameterContentTopic[index-1].value=$event;
                }
                else if(type=='message')
                {
                    this.$refs.parameterContentMessage[index-1].value=$event;
                }
            },
            closePopUp(type){
                this.parametersMap = new HashMap();
                this.defaultMap = new HashMap();
                this.popUpMessage = 0;
                this.popUpTopic = 0;
                this.showPopUps=0;
                if(type=='topic'){
                    this.showPopUp('message');
                }
            },
            setOldValue(type,index) {
                var temp=this.findOldValue(index);
                this.parametersMap.set(this.parametersMap.keys()[index-1],temp );
                if(type=='topic'){
                    this.$refs.parameterContentTopic[index-1].value=temp;
                }
                else if(type=='message')
                {
                    this.$refs.parameterContentMessage[index-1].value=temp;
                }
            },
            findOldValue(index){
                var temp='';
                for(var i=0;i<this.oldValues.length;i++){
                    if(this.oldValues[i].key==this.parametersMap.keys()[index-1]){
                        temp = this.oldValues[i].value;
                        this.parametersMap.set(this.oldValues[i].key,temp);
                    }
                }
                return temp;
            }
        }
    }
</script>