<template>
    <div>
        <v-layout>
            <v-flex d-flex md11>
                <!--Drop down menu to select the demonstration-->
                <Selector  :demonstrations="demonstrations"
                           @actionPanel="actionPanel=$event"
                           @selected="selected=$event"
                           @selectedDemoIndex="selectedDemoIndex=$event"
                           @selectedActionIndex="selectedActionIndex=$event"
                           :editPopUp="editPopUp"
                           @editPopUp="editPopUp=$event"
                           :deletePopUp="deletePopUp"
                           @deletePopUp="deletePopUp=$event"
                           :selectedActionIndex="selectedActionIndex"
                           :showBtn="showBtn"
                           @showBtn="showBtn=$event"
                           :actionPanel="actionPanel"
                           :userGroups="userGroups"></Selector>

                <!--Action buttons related to the demonstration choosed by the user-->
                <ActionPanel :selected="selected"
                             :actionPanel="actionPanel"
                             :deletePopUp="deletePopUp"
                             @deletePopUp="deletePopUp=$event"
                             :editPopUp="editPopUp"
                             @editPopUp="editPopUp=$event"
                             :demonstrations="demonstrations"
                             :selectedActionIndex="selectedActionIndex"
                             :selectedDemoIndex="selectedDemoIndex"
                             @actionPanel="actionPanel=$event"
                             @selectedActionIndex="selectedActionIndex=$event"></ActionPanel>
            </v-flex>
        </v-layout>

        <v-flex d-flex md10 offset-md1>
            <!--Publish panel permitting to send a message to a certain topic-->
            <!--PopUp permitting to change parameters to the message to send-->
            <!--PopUp permitting to change parameters to the topic where we want to publish-->
            <v-flex md7>
                <PublishPanel :publishPanel="publishPanel"
                              :topic="topic"
                              :messageToSend="messageToSend"
                              @topic="topic=$event"
                              @messageToSend="messageToSend=$event"
                              :actualTopic="actualTopic"
                              :actualMessage="actualMessage"
                              :demonstrations="demonstrations"
                              :selectedActionIndex="selectedActionIndex"
                              :selectedDemoIndex="selectedDemoIndex"
                              :popUps="popUps"
                              @popUps="popUps=$event"
                              @oldValuesTab="oldValuesTab=$event"
                              :oldValuesTab="oldValuesTab"></PublishPanel>
            </v-flex>

            <v-flex md4 offset-md1>
                <!--Subscribe panel permitting to subscribe to certain topics and receive message from them-->
                <SubscribePanel :selectedDemoIndex="selectedDemoIndex"
                                :demonstrations="demonstrations"
                                :subscribedTopics="subscribedTopics"
                                @subscribedTopics="subscribedTopics=$event"
                                @oldValuesTab="oldValuesTab=$event"
                                :oldValuesTab="oldValuesTab"></SubscribePanel>
            </v-flex>
        </v-flex>

        </br></br>
        <!--Panels who permits to add a new action or demonstration-->
        <AddingPanel :selected="selected"
                     :userGroups="userGroups"
                     :demonstrations="demonstrations"
                     :selectedActionIndex="selectedActionIndex"
                     :selectedDemoIndex="selectedDemoIndex"></AddingPanel>

        </br></br>

        <!--Inbox who shows message received on the topics that the user has subscribed-->
        <Inbox v-if="!this.connection"
               :subscribedTopics="subscribedTopics"
               @subscribedTopics="subscribedTopics"></Inbox>
    </div>
</template>

<script>
    import ConnectionPopUp from "./ConnectionPopUp";
    var utils= require('@/assets/js/Utils.js');
    import {config} from '@/assets/js/Utils.js';
    import axios from 'axios';
    import Selector from './Selector.vue'
    import ActionPanel from './ActionPanel.vue'
    import PublishPanel from './PublishPanel.vue'
    import SubscribePanel from './SubscribePanel.vue'
    import AddingPanel from './AddingPanel.vue'
    import Inbox from './Inbox.vue'

    export default {
        name: 'Body',
        components:{
            ConnectionPopUp,
            Selector,
            ActionPanel,
            PublishPanel,
            SubscribePanel,
            AddingPanel,
            Inbox
        },
        data: function () {

            return {
                //Panels variables
                publishPanel: null,
                actionPanel: null,

                //Publish Panel content
                messageToSend: '',
                topic: '',

                //Connection variables
                connection: true,

                //Demonstrations
                selected: null,
                demonstrations:[],
                userGroups:[],
                selectedUserGroup : {
                    id:1,
                    isSelected:false,
                    name:'WLDD',
                },

                //Variables for Hashmaps
                actualTopic : '',
                actualMessage : '',

                //Indexes
                selectedDemoIndex : null,
                selectedActionIndex : null,

                //PopUps Variables
                popUps : null,
                deletePopUp:false,
                editPopUp:false,

                showBtn : 0,    //Variable for editing buttons

                subscribedTopics : [],  //Tab who saves subscribed topics
                oldValuesTab : [{"key":"{{test}}","value":"{{test}}"}],  //Tab who saves last value used for a parameter
            }
        },

        watch:{
          selected:function(){
              this.topic = '';
              this.messageToSend = '';
          }
        },

        //Permits to get all data when starting the website
    mounted(){
        axios
            .get(config.baseLink+'/user/findAll')
            .then((responses) =>{
                this.userGroups = [];
                this.userGroups = responses.data;
                for(var i = 0; i<this.userGroups.length;i++)
                {
                    this.userGroups[i].isSelected=false;
                }
            }, (responses) =>{
                console.log('erreur',responses);
            })
    },
        methods: {
            //Permits to import data from webservice database
            update(callback=null){
                axios
                    .get(config.baseLink+'/demo/findByUserGroupId?userGroupId='+this.selectedUserGroup.id)
                    .then((responses) =>{
                        this.demonstrations = [];
                        this.demonstrations=responses.data;
                        for(var j=0;j<this.demonstrations.length;j++)
                        {
                            for(var i=0;i<this.demonstrations[j].action.length;i++)
                            {
                                this.demonstrations[j].action[i].demo=this.selected;
                                this.demonstrations[j].action[i].isSelected=false;
                                this.demonstrations[j].action[i].topicSubscribe=this.demonstrations[j].action[i].topic;
                                this.demonstrations[j].action[i].topicOriginal=this.demonstrations[j].action[i].topic;
                                this.demonstrations[j].action[i].messageOriginal=this.demonstrations[j].action[i].message;
                                this.demonstrations[j].action[i].messageOriginal=this.demonstrations[j].action[i].message;
                            }
                        }
                        if(this.selected!=null)
                        {
                            this.selected = this.demonstrations.filter(demonstration => demonstration.id == this.selected.id)[0];
                        }
                        if(callback!=null){
                            callback();
                        }
                    }, (response)=>{
                    console.log('erreur',response)
                })
            },

            //Permits to fill the publish panel when we select an action
            assignTopic(action) {
                this.topic = action.topic;
                this.actualTopic = action.topicOriginal;
                this.messageToSend = action.message;
                this.actualMessage = action.messageOriginal;
                this.publishPanel = 0;
                this.selectedActionIndex = this.demonstrations[this.selectedDemoIndex].action.indexOf(action);
                this.popUps = 1;
                this.showBtn = 1;

            }
        },
    }
</script>

