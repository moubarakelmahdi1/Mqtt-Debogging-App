<template>
    <v-flex d-flex offset-md1 md10 >
        <v-flex  md6 xs6>
            <v-expansion-panel>
                <v-expansion-panel-content>
                    <template v-slot:header>
                        <div class="strongTexts">Add Demonstration</div>
                    </template>

                    <v-flex offset-md1 md10>
                        </br>


                        <v-form @submit.prevent>
                            <v-text-field
                                    label="Demonstration Name"
                                    v-model="newDemoName"
                                    box>
                            </v-text-field>

                            <div class="userGroups">
                                <v-flex v-for="userGroup in userGroups" xs5 offset-xs1>
                                    <!--Checkboxes to select certain topics-->
                                    <input @click="userGroup.isSelected=!userGroup.isSelected" type="checkbox" :id="userGroup.id" class="checkboxesInAddingPanel">
                                    <div slot="label">
                                        {{userGroup.name}}
                                    </div>
                                </v-flex>
                            </div>

                            <br>

                            <v-flex>
                                <v-btn  type="submit"
                                        class="addButton"
                                       color=rgba(0,103,160,1)
                                       @click="addDemo()">
                                    <div class="button">ADD DEMO</div>
                                </v-btn>
                            </v-flex>
                        </v-form>
                    </v-flex>
                </v-expansion-panel-content>
            </v-expansion-panel>
        </v-flex>

        <v-flex offset-md1 md6 xs6 offset-xs1>
            <v-expansion-panel v-if="selected!=null">
                <v-expansion-panel-content>
                    <template v-slot:header>
                        <div class="strongTexts">Add Action</div>
                    </template>

                    <v-flex offset-md1 md10 offset-xs1>
                        </br>

                        <v-form @submit.prevent>
                            <v-text-field
                                    label="Action Name"
                                    v-model="newActionName"
                                    box>
                            </v-text-field>

                            <v-text-field
                                    label="Action Topic"
                                    v-model="newActionTopic"
                                    box>
                            </v-text-field>

                            <v-textarea
                                    label="Action Message"
                                    v-model="newActionMessage"
                                    box>
                            </v-textarea>

                            <v-flex>
                                <v-btn  type="submit"
                                        class="addButton"
                                       color=rgba(0,103,160,1)
                                       @click="addAction()">
                                    <div class="button">ADD ACTION</div>
                                </v-btn>
                            </v-flex>
                        </v-form>
                    </v-flex>
                </v-expansion-panel-content>
            </v-expansion-panel>

            <!--PopUp permitting to change parameters to the message to send-->
            <v-dialog
                    v-model="popUpMessage"
                    width="500"
                    persistent="">
                <template v-slot:activator="{ on }">

                </template>

                <v-card>
                    <v-card-title  class="headline grey lighten-2"
                                   primary-title>
                        Fill default parameters for Message
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
                            <v-flex md6 d-flex>
                                <v-text-field
                                        v-model="newDefaultValues[index-1]"
                                        solo>
                                </v-text-field>
                            </v-flex>
                        </v-flex>

                        <v-card-actions>
                            <v-spacer></v-spacer>

                            <v-btn  type="submit"
                                    color="primary"
                                    flat
                                    @click="setDefaultParams('message')">
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
                <template v-slot:activator="{ on }">

                </template>

                <v-card>
                    <v-card-title  class="headline grey lighten-2"
                                   primary-title>
                        Fill default parameters for Topic
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
                            <v-flex md6 d-flex>
                                <v-text-field
                                        v-model="newDefaultValues[index-1]"
                                        solo>
                                </v-text-field>
                            </v-flex>
                        </v-flex>

                        <v-card-actions>
                            <v-spacer></v-spacer>

                            <v-btn  type="submit"
                                    color="primary"
                                    flat
                                    @click="setDefaultParams('topic')">
                                Apply
                            </v-btn>
                        </v-card-actions>
                    </v-form>
                </v-card>
            </v-dialog>

            <v-dialog v-model="addedPopUp"
                      class="headline grey lighten-2"
                      primary-title
                      max-width="200">
                <template v-slot:activator="{ on }">

                </template>

                <v-card>
                    <v-card-title  class="headline grey lighten-2"
                                   primary-title>
                        {{type}} added
                    </v-card-title>

                    <v-card-actions>
                        <v-spacer></v-spacer>

                        <v-btn
                                color="primary"
                                flat
                                @click="addedPopUp=false">
                            Close
                        </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </v-flex>
    </v-flex>
</template>

<script>
    import {config} from '@/assets/js/Utils.js';
    import axios from 'axios';
    var HashMap = require('hashmap');

    export default {
        name: "AddingPanel",
        props:{
            'selected' : Object,
            'userGroups' : Array,
            'demonstrations': Array,
            'selectedActionIndex': Number,
            'selectedDemoIndex': Number,
        },
        data: function () {
            return {
                //Adding variables
                newDemoName:'',
                newActionName:'',
                newActionTopic:'',
                newActionMessage:'',
                userGroupList : '',
                parametersMap: new HashMap(),
                parametersIds: new HashMap(),
                popUpMessage: 0,
                popUpTopic: 0,
                newDefaultValues:[],
                addedPopUp : false,
                type : '',
            }
        },
        methods: {
            //Permits to add a new demonstration
            addDemo() {
                var items = document.getElementsByClassName('checkboxesInAddingPanel');
                for (var i = 0; i < items.length; i++) {
                    if (items[i].type == 'checkbox')
                        items[i].checked = false;
                }

                if(this.newDemoName.length>0)
                {
                    this.userGroups.forEach(userGroup => {
                        if (userGroup.isSelected == true) {
                            this.userGroupList = this.userGroupList + userGroup.id + '|';
                            userGroup.isSelected = false;
                        }
                    })
                    if(this.userGroupList.length>0)
                    {
                        axios
                            .post(config.baseLink + '/demo/addDemo?name=' + encodeURI(this.newDemoName) + '&userGroupsIds=' + encodeURI(this.userGroupList)+'&adminId='+localStorage.getItem("WLDDMQ_id"))
                            .then((responses) => {
                                this.$parent.update();
                                this.newDemoName = '';
                                this.userGroupList = '';
                                this.type = "Demonstration";
                                this.addedPopUp = true;
                            }, (response) => {
                                console.log('erreur', response)
                            })
                    }
                    else {
                        alert('Select demonstration user groups!')
                        }

                }
                else{
                    alert('Fill demonstration name!')
                }

            },
            //Permits to Add a new action for a demonstration
            addAction() {
                if(this.newActionName.length>0&&this.newActionTopic.length>0)
                {
                    axios
                        .post(config.baseLink + '/action/addAction?demoId=' + this.selected.id + '&name=' + encodeURI(this.newActionName) + '&topic=' + encodeURI(this.newActionTopic) + '&message=' + encodeURI(this.newActionMessage)+'&adminId='+localStorage.getItem("WLDDMQ_id"))
                        .then((responses) => {
                            this.$parent.update(()=>{
                                this.showParamsPopUp('topic',this.$parent.demonstrations);
                            });
                        }, (response) => {
                            console.log('erreur', response)
                        })
                }
                else{
                    alert('Fill action name and topic!')
                }

            },
            //Permits to show the popUp to fill parameters
            showParamsPopUp(type,demonstrations) {
                const regex = /\{\{[a-zA-Z0-9]*\}\}/gm;
                let matches;
                if (type == 'topic') {
                    matches = this.newActionTopic.matchAll(regex);
                } else if (type == 'message') {
                    matches = this.newActionMessage.matchAll(regex);
                }
                for (const match of matches) {
                    this.parametersMap.set(match[0], match[0]);
                    if (type == 'topic') {
                        this.parametersIds.set(match[0], demonstrations[this.selectedDemoIndex].action.filter(element => element.topic == this.newActionTopic&&element.name==this.newActionName)[0].parametersTopics.filter(element => element.parameter == match[0])[0].id);
                    } else if (type == 'message') {
                        this.parametersIds.set(match[0], demonstrations[this.selectedDemoIndex].action.filter(element => element.message == this.newActionMessage&&element.name==this.newActionName)[0].parametersMessages.filter(element => element.parameter == match[0])[0].id);
                    }
                }
                if (this.parametersMap.size > 0) {
                    if (type == 'topic') {
                        this.popUpTopic = 1;
                    } else if (type == 'message') {
                        this.popUpMessage = 1;
                    }
                } else {
                    if (type == 'topic') {
                        this.$parent.update(() => {
                            this.showParamsPopUp('message', this.$parent.demonstrations);
                        });
                    }
                    else{
                        this.showAddedPopUp();
                    }
                }
            },
            //Permits to close param adding modal
            closeParamEditing(){
                this.popUpTopic = 0;
                this.popUpMessage = 0;
                this.parametersMap = new HashMap();
                this.parametersIds = new HashMap();
                this.newDefaultValues = [];
            },
            //Permits to fill default parameter values
            setDefaultParams(type)
            {
                var toSend = new Array();
                for (var i = 0; i < this.parametersIds.size; i++) {
                    var temp = new Object();
                    temp.id = this.parametersIds.values()[i];
                    temp.value = this.newDefaultValues[i];
                    toSend.push(temp);
                }
                axios
                    .post(config.baseLink + '/parameters/addAllParametersDefaultValues?jsonString='+encodeURI(JSON.stringify(toSend)))
                    .then((responses) => {
                        if (type == 'topic') {
                            this.$parent.update(() => {
                                this.showParamsPopUp('message', this.$parent.demonstrations);
                            });
                            this.closeParamEditing();
                        } else {
                            this.$parent.update();
                            this.closeParamEditing();
                            this.showAddedPopUp();
                        }
                    }, (response) => {
                        console.log('erreur', response)
                    })
            },
            //Permits to show a popUp when we add an action
            showAddedPopUp(){
                this.newActionName = '';
                this.newActionMessage = '';
                this.newActionTopic = '';
                this.type = "Action";
                this.addedPopUp = true;
            }
        }
    }
</script>


