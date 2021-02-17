<!--Subscribe panel permitting to subscribe to certain topics and receive message from them-->
<template>
    <v-flex offset-xs1>
        <v-flex>
            <v-expansion-panel v-if="demonstrations[selectedDemoIndex]!=null">
                <v-expansion-panel-content>
                    <template v-slot:header>
                        <div class="strongTexts">Subscribe</div>
                    </template>

                    <v-card>
                        <div class="subscribesGroup">
                            <v-flex v-for="action in demonstrations[selectedDemoIndex].action"
                                    md4
                                    xs-4
                                    offset-xs1
                                    offset-md1>

                                <br>

                                <v-flex>
                                        <input @click="showPopUpSubscribe(action)" type="checkbox" :id="action.name" class="checkboxes">
                                </v-flex>

                                <label class="subscribeLabels">{{action.name}}</label>

                            </v-flex>

                            <v-flex>
                                <!--Subscribe button permitting to subscribe to the topics selected by the user-->
                                <v-btn class="subscribeButton"
                                       color=rgba(0,103,160,1)
                                       @click="subscribeTopic()">
                                    <div class="button">Subscribe</div>
                                </v-btn>

                                <v-btn class="subscribeButton"
                                       color=rgba(0,103,160,1)
                                       @click="addTopic = 1">
                                    <div class="button">Add Topic Subscribtion</div>
                                </v-btn>
                            </v-flex>
                        </div>
                    </v-card>
                </v-expansion-panel-content>
            </v-expansion-panel>
        </v-flex>

        <v-dialog
                v-model="popUpSubscribe"
                width="500"
                persistent="">
            <template v-slot:activator="{ on }">

            </template>

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
                                    @change="setValue(index,$event)"
                                    :value="findOldValue(index)"
                                    solo>
                            </v-text-field>
                            <div class="defaultValuebutton">
                                <v-tooltip top>
                                    <template v-slot:activator="{ on }">
                                        <v-btn fab small @click="setDefaultValue(index)" v-on="on">
                                            <v-icon dark>build</v-icon>
                                        </v-btn>
                                    </template>
                                    <span>{{defaultMap.values()[index-1]}}</span>
                                </v-tooltip>
                            </div>
                        </v-flex>
                    </v-flex>

                    <v-card-actions>
                        <v-spacer></v-spacer>

                        <v-btn  type="submit"
                                color="primary"
                                flat
                                @click="replaceText()">
                            Apply
                        </v-btn>
                    </v-card-actions>
                </v-form>
            </v-card>
        </v-dialog>

        <v-dialog
                v-model="addTopic"
                width="500"
                persistent="">
            <template v-slot:activator="{ on }">

            </template>

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    Enter topic
                </v-card-title>

                <v-text-field v-model="newTopicSubscription"
                              label="Topic"
                              solo>
                </v-text-field>

                <v-card-actions>
                    <v-btn color="primary"
                           flat
                           @click="cancelNewTopicSubscribtion()">
                        Cancel
                    </v-btn>

                    <v-spacer></v-spacer>

                    <v-btn  color="primary"
                            flat
                            @click="subscribeNewTopic()">
                        Add
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-flex>
</template>

<script>
    const matchAll = require("match-all");
    var HashMap = require('hashmap');
    import {subscribeMQTT} from '@/assets/js/Utils.js';

    export default {
        name: 'SubscribePanel',
        props: {
            'demonstrations': Array,
            'subscribedTopics' : Array,
            'selectedDemoIndex': Number,
            'oldValuesTab' : Array
        },
        data: function () {
            return {
                popUpSubscribe: 0,
                parametersMap: new HashMap(),
                topicOriginal: '',
                topicSubscribe: '',
                addTopic : 0,
                newTopicSubscription : '',
                defaultMap: new HashMap(),
                topicSubscribed : [],
                oldValues : [{"key":"{{test}}","value":"{{test}}"}],
            }
        },
        watch:{
          topicSubscribed:function(){
              this.$emit('subscribedTopics',this.topicSubscribed);
          },
          selectedDemoIndex:function(){
              var items = document.getElementsByClassName('checkboxes');
              for (var i = 0; i < items.length; i++) {
                  if (items[i].type == 'checkbox')
                      items[i].checked = false;
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
            //Permits to replace parameters
            replaceText() {
                for (var i = 0; i < this.parametersMap.size; i++) {
                    this.demonstrations.some(element => {
                        element.action.forEach(act =>{
                            if (act.topicOriginal == this.topicOriginal) {
                                act.topicSubscribe = this.topicSubscribe.replace(this.parametersMap.keys()[i], this.parametersMap.values()[i]);
                                this.topicSubscribe = act.topicSubscribe;
                            }
                        })
                    });
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
                this.popUpSubscribe = 0;
                this.parametersMap = new HashMap();
                this.defaultMap = new HashMap();
            },

            //Permits to show parameters popUp for the topic we want to subscribe at
            showPopUpSubscribe(action) {
                if(!document.getElementById(action.name).checked==false)
                {
                    action.isSelected = true;
                    document.getElementById(action.name).checked = true;
                    const regex = /{{([a-zA-Z0-9]*)}}/gm;
                    this.topicSubscribe = action.topicOriginal;
                    this.topicOriginal = action.topicOriginal;
                    action.topicSubscribe = action.topicOriginal;
                    let matches = matchAll(action.topicOriginal,regex).toArray();
                    for (var i=0; i < matches.length; i++) {
                        this.parametersMap.set('{{'+matches[i]+'}}','{{'+ matches[i]+'}}');
                        this.defaultMap.set('{{'+matches[i]+'}}', action.parametersTopics.filter(element => element.parameter =='{{'+matches[i]+'}}')[0].parameterDefaultValue);
                    }
                    if(this.parametersMap.size>0)
                    {
                        this.popUpSubscribe = 1;
                    }
                }
                else{
                    document.getElementById(action.name).checked = false;
                    action.isSelected = false;

                }
            },

            //Permits to subscribe to a topic
            subscribeTopic() {
                this.demonstrations[this.selectedDemoIndex].action.forEach((action) => {
                    if (action.isSelected) {
                        subscribeMQTT(action.topicSubscribe);
                        var res = 0;
                        this.topicSubscribed.find(function(element){
                            if(element == action.topicSubscribe){
                                res = 1;
                            }
                            return res;
                        })
                        if(!res){
                            this.topicSubscribed.push(action.topicSubscribe);
                        }else{
                            console.log('coucou')
                        }
                    }
                    action.isSelected = false;
                    document.getElementById(action.name).checked = false;
                })
            },

            subscribeNewTopic(){
                if(this.newTopicSubscription.length>0)
                {
                    var res = 0;
                    var newTopic = this.newTopicSubscription;
                    if(newTopic!='')
                    {
                        this.topicSubscribed.find(function(element){
                            if(element == newTopic){
                                res = 1;
                            }
                            return res;
                        })
                        if(!res){
                            this.topicSubscribed.push(newTopic);
                        }
                        subscribeMQTT(this.newTopicSubscription);
                    }
                    this.cancelNewTopicSubscribtion();
                }
                else{
                    alert('Fill new topic name!');
                }
            },

            setDefaultValue(index) {
                this.parametersMap.set(this.parametersMap.keys()[index-1], this.defaultMap.values()[index-1]);
                    this.$refs.parameterContentTopic[index-1].value=this.defaultMap.values()[index-1];
            },

            setValue(index,$event){
                this.parametersMap.set(this.parametersMap.keys()[index-1],$event);
                    this.$refs.parameterContentTopic[index-1].value=$event;
            },

            cancelNewTopicSubscribtion(){
                this.newTopicSubscription = '';
                this.addTopic = 0;
            },
            setOldValue(type,index) {
                var temp=this.findOldValue(index);
                this.parametersMap.set(this.parametersMap.keys()[index-1],temp );
                    this.$refs.parameterContentTopic[index-1].value=temp;
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