<template>
    <v-flex md9>
        <!--Action panel related to the demonstration choosed by the user-->
        <v-expansion-panel v-model="showActionPanel"   v-if="selected!=null"    >
            <v-expansion-panel-content>
                <template v-slot:header>
                    <div class="strongTexts">Actions</div>
                </template>

                <v-card>
                    <div class="actionsGroup">
                        <v-flex v-for="action in selected.action"
                                class="action"
                                md3>
                            <v-flex>
                                <v-btn color=rgba(0,103,160,1)
                                       @click="assignTopic(action)"
                                       block>
                                    <div class="button" v-if="actionId==action.id">></div>
                                    <div class="button" style="white-space: pre-wrap; font-size: 12px">{{action.name}}</div>
                                    <div class="button" v-if="actionId==action.id"><</div>
                                </v-btn>
                            </v-flex>
                        </v-flex>
                    </div>
                </v-card>
            </v-expansion-panel-content>
        </v-expansion-panel>

        <!--Confirmation popUp when deleting an action-->
        <v-dialog v-model="deletePopUp"
                width="550">
            <template v-slot:activator="{ on }">

            </template>

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    WARNING : Are you sure to delete the action : {{actionName}}
                </v-card-title>

                <v-card-actions>
                    <v-btn
                            color="primary"
                            flat
                            @click="deleteModal=false">
                        NO
                    </v-btn>

                    <v-spacer></v-spacer>
                    <v-btn
                            color="primary"
                            flat
                            @click="deleteAction()">
                        YES
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!--popUp for editing actions-->
        <v-dialog v-model="editModal"
                  width="550"
                  persistent="">
            <template v-slot:activator="{ on }">

            </template>

            <v-card @submit.prevent>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    <div class="edit">
                        Edit action : {{actionName}}
                    </div>
                    <v-spacer></v-spacer>

                    <div class="edit">Import</div>
                    <v-btn fab small color="rgba(0,103,160,1)" @click="$refs.inputUpload.click()">

                        <v-icon color="white">
                            cloud_upload
                        </v-icon>
                    </v-btn>
                    <input type="file"
                           ref="inputUpload"
                           id="jsonAction" name="jsonAction"
                           accept=".json"
                           v-show="false"
                           @change="importAction($event,demonstrations[selectedDemoIndex].id)">

                    <div class="edit">Export</div>
                    <v-btn fab small color="rgba(0,103,160,1)" @click="exportAction()">
                        <v-icon color="white">
                            cloud_download
                        </v-icon>
                    </v-btn>
                </v-card-title>


                <v-form>
                    <v-text-field
                            label="Action Name"
                            v-model="newActionName"
                            solo>
                    </v-text-field>

                    <v-text-field
                            label="Action Topic"
                            v-model="newActionTopic"
                            solo>
                    </v-text-field>

                    <v-textarea
                            label="Action Message"
                            v-model="newActionMessage"
                            solo>
                    </v-textarea>

                    <v-card-actions>
                        <v-btn
                                color="primary"
                                flat
                                @click="cancelEditModal()">
                            CANCEL
                        </v-btn>

                        <v-spacer></v-spacer>

                        <v-btn  type="submit"
                                color="primary"
                                flat
                                @click="editAction()">
                            SAVE
                        </v-btn>
                    </v-card-actions>
                </v-form>
            </v-card>
        </v-dialog>

        <!--PopUp permitting to change parameters for the message of the action that we are editing-->
        <v-dialog
                v-model="popUpMessage"
                width="500"
                persistent>
            <template v-slot:activator="{ on }">

            </template>

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    Fill default parameters for Message
                </v-card-title>

                </br>

                <v-form @submit.prevent="setDefaultParams('message')">
                    <v-flex d-flex
                            v-for="index in parametersMap.size">
                        <v-flex md3 offset-md1 offset-xs1>
                            <div class="parameters">
                                {{parametersMap.keys()[index-1]}}
                            </div>
                        </v-flex>
                        <v-flex md6 d-flex>
                            <v-text-field
                                    ref="parameterContentMessage"
                                    @change="setValue('message',index,$event)"
                                    :value="findValueExisting(index)"
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

        <!--PopUp permitting to change parameters for the topic of the action that we are editing-->
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

                <v-form @submit.prevent="setDefaultParams('topic')">
                    <v-flex d-flex
                            v-for="index in parametersMap.size">
                        <v-flex md3 offset-md1 offset-xs1>
                            <div class="parameters">
                                {{parametersMap.keys()[index-1]}}
                            </div>
                        </v-flex>
                        <v-flex md6 d-flex>
                            <v-text-field
                                    ref="parameterContentTopic"
                                    @change="setValue('topic',index,$event)"
                                    :value="findValueExisting(index)"
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

        <v-dialog v-model="importConfirmation"
                  width="550">
            <template v-slot:activator="{ on }">

            </template>

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    Action Imported!
                </v-card-title>

                <v-card-actions>
                    <v-btn
                            color="primary"
                            flat
                            @click="importConfirmation=0">
                        Close
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-flex>
</template>

<script>
    import {config} from '@/assets/js/Utils.js';
    import axios from 'axios';
    var HashMap = require('hashmap');


    export default {
        name: 'ActionPanel',
        props:{
            'actionPanel':Number,
            'selected': Object,
            'deletePopUp' : Boolean,
            'editPopUp' : Boolean,
            'demonstrations': Array,
            'selectedActionIndex': Number,
            'selectedDemoIndex': Number,
        },
        data:function(){
            return {
                showActionPanel : this.actionPanel,
                deleteModal:this.deletePopUp,
                actionName:null,
                actionId:null,
                editModal : this.editPopUp,
                newActionName:'',
                newActionTopic:'',
                newActionMessage:'',
                parametersMap: new HashMap(),  //Hashmap with all the parameters
                parametersIds: new HashMap(), //Hashmap with parameters Id's
                popUpMessage: 0,//popUp for filling message parameters of the action that wa are editing
                popUpTopic: 0,  //popUp for filling topic parameters of the action that wa are editing
                newDefaultValues:[],  //new default values of the action that we are editing
                actionIndex : this.selectedActionIndex,  //index of the selected action

                tempParameters : [],                 //copy of default values for the action that we want to edit
                importConfirmation : 0,
            }
        },
        watch:{
            actionPanel:function(){
                this.showActionPanel = this.actionPanel;
            },
            selected:function(){
                this.showActionPanel = 0;
            },
            deletePopUp:function(){
                this.deleteModal = this.deletePopUp;
            },
            deleteModal:function(){
                this.$emit('deletePopUp',this.deleteModal);
            },
            editPopUp:function(){
                this.editModal = this.editPopUp;
                if(this.editModal==true)
                {
                    this.newActionName = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].name;
                    this.newActionTopic = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].topicOriginal;
                    this.newActionMessage = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].messageOriginal;
                }
            },
            editModal:function(){
                this.$emit('editPopUp',this.editModal);
            },
            showActionPanel:function(){
                this.$emit('actionPanel',this.showActionPanel);
            },
            selectedActionIndex:function(){
                this.actionIndex = this.selectedActionIndex;
            },
            actionIndex:function(){
                this.$emit('selectedActionIndex',this.actionIndex);
            }
        },
        methods: {
            //permits to select an action
            assignTopic(action) {
                this.actionName = action.name;
                this.actionId = action.id;
                this.$parent.assignTopic(action);
                this.newActionName = action.name;
                this.newActionTopic = action.topic;
                this.newActionMessage = action.message;
            },
            //permits to delete an action
            deleteAction() {
                axios
                    .post(config.baseLink + '/action/deleteAction?actionId=' + this.actionId)
                    .then((responses) => {
                        this.$parent.update();
                        this.deleteModal = false;
                        this.newActionName = '';
                        this.newActionMessage = '';
                        this.newActionTopic = '';
                        this.actionIndex = null;
                    }, (response) => {
                        console.log('erreur', response)
                    })
            },
            //Permits to Add a new action for a demonstration
            editAction() {
                if(this.newActionName!=''&&this.newActionTopic!='')
                {
                    axios
                        .post(config.baseLink + '/action/editAction?actionId=' + this.actionId + '&name=' + encodeURI(this.newActionName) + '&topic=' + encodeURI(this.newActionTopic) + '&message=' + encodeURI(this.newActionMessage)+'&lastEditionId='+localStorage.getItem("WLDDMQ_id"))
                        .then((responses) => {
                            console.log(this.demonstrations[this.selectedDemoIndex].action[this.actionIndex]);
                            this.demonstrations[this.selectedDemoIndex].action[this.actionIndex].parametersTopics.forEach(element => this.tempParameters.push(element));
                            this.demonstrations[this.selectedDemoIndex].action[this.actionIndex].parametersMessages.forEach(element => this.tempParameters.push(element));
                            this.$parent.update(() => {
                                this.showParamsPopUp('topic', this.$parent.demonstrations);
                            });
                            this.editModal = false;
                        }, (response) => {
                            console.log('erreur', response)
                        })
                }
                else{
                    alert('Fill action name and topic!')
                }

            },
            //Permits to show the popUp to fill parameters
            showParamsPopUp(type, demonstrations) {
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
                        this.parametersIds.set(match[0], demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].parametersTopics.filter(element => element.parameter == match[0])[0].id);
                    } else if (type == 'message') {
                        this.parametersIds.set(match[0], demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].parametersMessages.filter(element => element.parameter == match[0])[0].id);
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
                    }else{
                        this.tempParameters = [];

                    }
                }
            },
            //Permits to close editing modal
            cancelEditModal() {
                this.editModal = 0;
                this.newActionName = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].name;
                this.newActionTopic = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].topic;
                this.newActionMessage = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].message;
            },
            //Permits to close param editing modal
            closeParamEditing() {
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
                            this.tempParameters = [];
                        }
                    }, (response) => {
                        console.log('erreur', response)
                    })
            },
            //Permits to search existing value for a parameter when editing an action
            findValueExisting(index){
                var temp='';
                for(var i=0;i<this.tempParameters.length;i++){
                    if(this.tempParameters[i].parameter==this.parametersMap.keys()[index-1]){
                        temp = this.tempParameters[i].parameterDefaultValue;
                        this.parametersMap.set(this.tempParameters[i].parameter,temp);
                        this.newDefaultValues[index-1] = temp;
                    }
                }
                return temp;
            },
            //Permit to set value for a parameter
            setValue(type,index,$event){
                this.parametersMap.set(this.parametersMap.keys()[index-1],$event);
                if(type=='topic'){
                    this.$refs.parameterContentTopic[index-1].value=$event;
                    this.newDefaultValues[index-1] = $event;
                }
                else if(type=='message')
                {
                    this.$refs.parameterContentMessage[index-1].value=$event;
                    this.newDefaultValues[index-1] = $event;
                }
            },
            exportAction(){
                axios
                    .get(config.baseLink +'/action/getActionById?actionId='+this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].id)
                    .then((responses) => {
                        let jsonAction = responses.data;
                        delete jsonAction.id;
                        jsonAction.parametersTopics.forEach(element => delete element.id);
                        jsonAction.parametersMessages.forEach(element => delete element.id);
                        let dataStr = JSON.stringify(jsonAction);
                        let dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
                        let exportFileDefaultName = this.demonstrations[this.selectedDemoIndex].action[this.selectedActionIndex].name+'_action'+'.json';
                        let linkElement = document.createElement('a');
                        linkElement.setAttribute('href', dataUri);
                        linkElement.setAttribute('download', exportFileDefaultName);
                        linkElement.click();
                    }, (response) => {
                        console.log('erreur', response)
                    })
            },
            importAction(event,demoId){
                var reader = new FileReader();
                reader.onload = function(event) {
                    var jsonObj = JSON.parse(event.target.result);
                    console.log(demoId)
                    axios
                        .post(config.baseLink + '/action/importAction?actionJson='+ encodeURI(JSON.stringify(jsonObj))+'&demoId='+demoId)
                        .then((responses) => {
                            this.$parent.update();
                            this.cancelEditModal();
                            this.importConfirmation = 0;
                        }, (response) => {
                            console.log('erreur', response)
                        })
                }
                reader.readAsText(event.target.files[0]);
                event.target.value = '';
                this.importConfirmation = 1;
                this.$parent.update();
                this.cancelEditModal();
            }
        }
    }
</script>
