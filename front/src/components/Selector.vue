<!--Drop down menu to select the demonstration-->
<template>
    <v-flex md3 offset-md1>
        <v-select solo
                  v-model="selected"
                  :items="demonstrations"
                  item-text="name"
                  label="Demonstrations"
                  class="strongTexts"
                  return-object
                  @input="atInput()"
                  prepend-icon="build"
                  @click:prepend="showEditDemoPopUp()"
        ></v-select>

        <div v-if="selectedActionIndex!=null&&showButtons&&actionPanel!=null&&demonstrations[demoIndex].action.length>0" class="editButtons">
            <v-btn
                    small class="button"
                   color=rgba(0,103,160,1)
                   @click="editModal=true">
                <div class="button">EDIT</div>
            </v-btn>

            <v-btn small class="button"
                   color=rgba(0,103,160,1)
                   @click="deleteModal=true">
                <div class="button">DELETE</div>
            </v-btn>
        </div>

        <br>

        <div v-if="selectedActionIndex!=null&&showButtons&&actionPanel!=null&&demonstrations[demoIndex].action.length>0" class="editButtons">
            <v-btn  v-if="actionIndex!=0"
                    small
                    color=rgba(0,103,160,1)
                    @click="changeSorting('left')">
                <div class="button"><</div>
            </v-btn>

            <v-btn  v-else
                    disabled
                    small>
                <div class="button"><</div>
            </v-btn>


            <v-btn  v-if="actionIndex<demonstrations[demoIndex].action.length-1"
                    small class="button"
                    color=rgba(0,103,160,1)
                    @click="changeSorting('right')">
                <div class="button">></div>
            </v-btn>

            <v-btn  v-else
                    disabled
                    small>
                <div class="button">></div>
            </v-btn>
        </div>

        <v-dialog
                v-model="editDemoPopUp"
                width="700"
                persistent="">
            <template v-slot:activator="{ on }">

            </template>

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    <div class="edit" v-if="selected!=null">
                        Edit demonstration : {{demonstrations[demoIndex].name}}
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
                           id="jsonDemo" name="jsonDemo"
                           accept=".json"
                           v-show="false"
                           @change="importDemo($event)">

                    <div class="edit">Export</div>
                    <v-btn fab small color="rgba(0,103,160,1)" @click="exportDemo()">
                        <v-icon color="white">
                            cloud_download
                        </v-icon>
                    </v-btn>
                    <div class="edit">Delete</div>
                    <v-btn fab small color="rgba(0,103,160,1)" @click="showDeleteDemoPopUp()">
                        <v-icon color="white">
                            remove
                        </v-icon>
                    </v-btn>
                </v-card-title>

                <v-form @submit.prevent>
                    <v-text-field
                            label="Demonstration Name"
                            v-model="newDemoName"
                            box>
                    </v-text-field>

                    <div class="userGroups">
                        <v-flex v-for="userGroup in userGroupInEdit" offset-md1 offset-xs1>
                            <!--Checkboxes to select certain topics-->
                            <input @click="userGroup.isSelected=!userGroup.isSelected" type="checkbox" :id="userGroup.id+10" class="checkboxesInSelector">
                            <div slot="label">
                                {{userGroup.name}}
                            </div>
                        </v-flex>
                    </div>

                    <v-card-actions>
                        <v-btn color="primary"
                               flat
                               @click="cancelEditDemoPopUp()">
                            Cancel
                        </v-btn>

                        <v-spacer></v-spacer>

                        <v-btn  color="primary"
                                flat
                                @click="editDemo()">
                            Save
                        </v-btn>
                    </v-card-actions>
                </v-form>
            </v-card>
        </v-dialog>

        <v-dialog v-model="deleteDemoPopUp"
                  width="550">
            <template v-slot:activator="{ on }">

            </template>

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    WARNING : Are you sure to delete the demonstration :
                </v-card-title>

                <v-card-actions>
                    <v-btn
                            color="primary"
                            flat
                            @click="deleteDemoPopUp=0">
                        NO
                    </v-btn>

                    <v-spacer></v-spacer>
                    <v-btn
                            color="primary"
                            flat
                            @click="deleteDemo()">
                        YES
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="importConfirmation"
                  width="550">
            <template v-slot:activator="{ on }">

            </template>

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    Demonstration Imported!
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
    export default {
        name: 'Selector',
        props:{
            'demonstrations':Array,
            'deletePopUp' : Boolean,
            'editPopUp' : Boolean,
            'selectedActionIndex' : Number,
            'showBtn' : Number,
            'actionPanel' : Number,
            'userGroups' : Array,
        },
        data: function () {
            return {
                selected : null,
                showActionPanel:null,
                demoIndex : null,
                actionIndex : this.selectedActionIndex,
                deleteModal:this.deletePopUp,
                editModal : this.editPopUp,
                showButtons : this.showBtn,
                editDemoPopUp : 0,
                newDemoName : '',
                userGroupList : '',
                deleteDemoPopUp : 0,
                toImportDemo : '',
                importConfirmation : 0,
                userGroupInEdit : this.userGroups,
            }
        },
        watch:{
            selected(){
                this.$emit('selected',this.selected);
                this.$emit('showActionPanel',this.showActionPanel);
                if(this.selected!=null){
                    this.demonstrations.forEach(element =>{
                        if(element.id==this.selected.id)
                        {
                            this.demoIndex = this.demonstrations.indexOf(element);
                        }
                    })
                    this.updateCheckBoxes();
                }
                this.$emit('selectedDemoIndex',this.demoIndex);
            },
            showActionPanel(){
                this.$emit('showActionPanel',this.showActionPanel);
            },
            deletePopUp:function(){
                this.deleteModal = this.deletePopUp;
            },
            deleteModal:function(){
                this.$emit('deletePopUp',this.deleteModal);
            },
            editPopUp:function(){
                this.editModal = this.editPopUp;
            },
            editModal:function(){
                this.$emit('editPopUp',this.editModal);
            },
            showButtons:function(){
                this.$emit('showBtn',this.showButtons);
            },
            showBtn:function(){
                this.showButtons = this.showBtn;
            },
            actionIndex:function(){
                this.$emit('selectedActionIndex',this.actionIndex);
            },
            selectedActionIndex:function(){
                this.actionIndex=this.selectedActionIndex;
            },
            userGroups:function(){
                this.userGroupInEdit = this.userGroups;
            }
        },
        methods: {
            updateCheckBoxes(){
              this.demonstrations[this.demoIndex].user.forEach(element => {
                  this.userGroupInEdit.forEach(e =>{
                      if(element.id == e.id){
                          document.getElementById(e.id+10).checked=true;
                          e.isSelected = true;
                      }
                  })
              })
            },
            atInput() {
                this.showActionPanel = 0;
                this.actionIndex = null;
                this.showButtons = 0;
            },
            changeSorting(direction) {
                var temp = null;
                if(direction=='left'){
                    temp = this.demonstrations[this.demoIndex].action[this.actionIndex-1];
                }
                else if(direction=='right'){
                    temp = this.demonstrations[this.demoIndex].action[this.actionIndex+1];
                }
                axios
                    .post(config.baseLink+'/action/editActionSorting?actionId='+this.demonstrations[this.demoIndex].action[this.actionIndex].id+'&permutedActionId='+temp.id+'&actionSort='+this.demonstrations[this.demoIndex].action[this.actionIndex].sort+'&permutedActionSort='+temp.sort)
                    .then((responses) =>{
                        this.$parent.update();
                        if(direction=='left'){
                            this.actionIndex = this.actionIndex-1;
                        }
                        else if(direction=='right'){
                            this.actionIndex = this.actionIndex+1;
                        }
                    }, (response)=>{
                        console.log('erreur',response)
                    })
            },
            showEditDemoPopUp(){
                if(this.selected!=null){
                    this.newDemoName = this.demonstrations[this.demoIndex].name;
                    this.editDemoPopUp = 1 ;
                }
            },
            cancelEditDemoPopUp(){
                this.editDemoPopUp = 0;
                this.newDemoName = '';
                this.$parent.update();
                this.updateCheckBoxes();
            },
            editDemo() {
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
                            .post(config.baseLink + '/demo/editDemo?demoId='+this.demonstrations[this.demoIndex].id+'&name='+encodeURI(this.newDemoName)+'&userGroupsIds='+encodeURI(this.userGroupList))
                            .then((responses) => {
                                this.$parent.update();
                                this.userGroupList = '';
                                this.selected=null;
                                this.cancelEditDemoPopUp();
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
            showDeleteDemoPopUp(){
                if(this.selected!=null){
                    this.deleteDemoPopUp = 1;
                }
            },
            deleteDemo(){
                axios
                    .post(config.baseLink + '/demo/deleteDemo?demoId=' + this.demonstrations[this.demoIndex].id)
                    .then((responses) => {
                        this.$parent.update();
                        this.selected = null;
                        this.deleteDemoPopUp = 0;
                        this.editDemoPopUp = 0;
                    }, (response) => {
                        console.log('erreur', response)
                    })
            },
            exportDemo(){
                axios
                    .get(config.baseLink +'/demo/getDemo?demoId='+ this.demonstrations[this.demoIndex].id)
                    .then((responses) => {
                        let jsonDemo = responses.data;
                        delete jsonDemo.id;
                        jsonDemo.action.forEach(element =>{
                            delete element.id;
                            element.parametersTopics.forEach(element => delete element.id)
                            element.parametersMessages.forEach(element => delete element.id)
                        });
                        let dataStr = JSON.stringify(jsonDemo);
                        let dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
                        let exportFileDefaultName = this.demonstrations[this.demoIndex].name+'.json';
                        let linkElement = document.createElement('a');
                        linkElement.setAttribute('href', dataUri);
                        linkElement.setAttribute('download', exportFileDefaultName);
                        linkElement.click();
                    }, (response) => {
                        console.log('erreur', response)
                    })
            },
            importDemo(event){
                var reader = new FileReader();
                reader.onload = function(event) {
                    var jsonObj = JSON.parse(event.target.result);
                    axios
                        .post(config.baseLink + '/demo/importDemo?demoJson=' + encodeURI(JSON.stringify(jsonObj)))
                        .then((responses) => {
                            this.$parent.update();
                            this.importConfirmation = 0;
                        }, (response) => {
                            console.log('erreur', response)
                        })
                }
                reader.readAsText(event.target.files[0]);
                event.target.value = '';
                this.importConfirmation = 1;
                this.$parent.update();
            }
        }
    }
</script>