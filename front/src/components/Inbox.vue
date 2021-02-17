<!--Inbox who shows message received on the topics that the user has subscribed-->
<template>
    <v-layout row justify-center>
        <v-flex xs12 sm12 md10>
            <v-card>
                <v-toolbar>
                    <v-toolbar-title>
                        Message
                    </v-toolbar-title>

                    <v-spacer></v-spacer>

                    <v-btn color=rgba(0,103,160,1)
                           @click="showTopicsSubscribed=1"
                           small
                           fab>
                        <div class="button" >{{subscribedTopics.length}}</div>
                    </v-btn>

                    <v-btn color=rgba(0,103,160,1)
                           @click="clearAll()">
                        <div class="button">Clear all ({{messagesReceived.length}})</div>
                    </v-btn>
                </v-toolbar>

                <v-list>
                    <template v-for="(messageReceived, index) in messagesReceived">
                        <v-list-tile
                                :key="index"
                                avatar
                                ripple
                                @click="selectMessage(messageReceived)"
                                :style="'border-left:solid '+messageReceived.color+' 5px;'">
                            <v-list-tile-content @click="dialog=true">
                                <v-list-tile-title class="inboxContent">{{ messageReceived.topic }}</v-list-tile-title>

                                <v-list-tile-sub-title class="inboxContent">
                                    {{ messageReceived.message }}
                                </v-list-tile-sub-title>
                            </v-list-tile-content>

                            <v-list-tile-action>
                                <v-list-tile-action-text>QoS : {{messageReceived.options.qos}} &nbsp;&nbsp;&nbsp; {{ messageReceived.date }}</v-list-tile-action-text>
                                <v-flex d-flex class="retainedAndClearButton">
                                    <v-list-tile-action-text v-if="messageReceived.options.retain==true">Retained&nbsp;&nbsp;&nbsp;</v-list-tile-action-text>
                                    <v-icon class="iconButton"
                                            @click="clearMessage(index)">
                                        remove_circle
                                    </v-icon>
                                </v-flex>
                            </v-list-tile-action>
                        </v-list-tile>

                        <v-divider v-if="index + 1 < messagesReceived.length" :key="`divider-${index}`"></v-divider>
                    </template>
                </v-list>
            </v-card>

            <v-dialog
                    v-model="showTopicsSubscribed"
                    width="700"
                    persistent="">
                <template v-slot:activator="{ on }">

                </template>

                <v-card>
                    <v-card-title  class="headline grey lighten-2"
                                   primary-title>
                        Topics you subscribed at
                    </v-card-title>

                    <div class="topicList">
                        <v-flex v-for="(topic,index) in subscribedTopicsTab" d-flex>
                            <div class="topicInList">
                                <strong style="font-size: 20px">.</strong>{{topic}}
                                <v-icon class="unsubscribe"
                                        @click="unsubscribe(topic,index)">
                                    remove_circle
                                </v-icon>
                            </div>
                        </v-flex>
                    </div>

                    <v-card-actions>
                        <v-btn color="primary"
                               flat
                               @click="showTopicsSubscribed=0">
                            Cancel
                        </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </v-flex>

        <!--Pop up who shows the complete message of a selected message-->
        <ShowMessagePopUp
                :dialog="dialog"
                @dialog="dialog=$event"
                :selectedMessage="selectedMessage"></ShowMessagePopUp>
    </v-layout>
</template>

<script>
    import ShowMessagePopUp from './ShowMessagePopUp.vue'
    import {unsubscribeMQTT,getMessage,returnDate,stringToRGB} from '@/assets/js/Utils.js';
    export default {
        name: "Inbox",
        components:{
            ShowMessagePopUp
        },
        props:{
            'subscribedTopics' : Array,
        },
        data: function () {
            return {
                //Inbox content
                messagesReceived:[],
                dialog: false,
                selectedMessage: null,
                showTopicsSubscribed:0,
                subscribedTopicsTab : this.subscribedTopics
            }
        },
        mounted(){
            getMessage((topic,message,options)=>{
                var received = {
                    message: message,
                    topic: topic,
                    options: options,
                    date: returnDate(),
                    color : stringToRGB(topic),
                }
                this.messagesReceived.unshift(received);
            })

        },
        watch:{
          subscribedTopicsTab:function(){
              this.$emit('subscribedTopics',this.subscribedTopicsTab);
          },
          subscribedTopics:function(){
              this.subscribedTopicsTab=this.subscribedTopics;
          }
        },
        methods:{
            //Permits to clear all the inbox
            clearAll(){
                this.messagesReceived=new Array();
            },

            //Permits to delete a message from the inbox
            clearMessage(index){
                this.messagesReceived.splice(index,1);
                this.selectedMessage=null;
            },
            //Permits to select a message in the inbox
            selectMessage(selectedMessage) {
                this.selectedMessage = selectedMessage;
            },
            unsubscribe(topic,index){
                unsubscribeMQTT(topic);
                this.subscribedTopicsTab.splice(index,1);
            }
        }
    }

</script>

