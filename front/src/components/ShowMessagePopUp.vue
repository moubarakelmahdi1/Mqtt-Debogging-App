<!--Pop up who shows the complete message of a selected message-->
<template>
    <v-dialog
            v-if="selectedMessage!=null"
            v-model="messageDialog"
            width="1000">
        <template v-slot:activator="{ on }">

        </template>

        <v-card>
            <v-card-text  class="headline grey lighten-2">
                <div>
                    <span id="messageDatePopUp">Date : {{selectedMessage.date}}</span>

                    <div id="messageTopicPopUp">Topic&nbsp;:&nbsp;{{selectedMessage.topic}}</div>
                </div>

            </v-card-text>

            <v-card-text>
                <div>
                    <pre v-if="selectedMessage.message[0]==123||selectedMessage.message[0]==91" class="messagePopUp">{{formatJson(selectedMessage.message)}}</pre>
                    <div v-else class="messagePopUp">{{formatJson(selectedMessage.message)}}</div>
                </div>
            </v-card-text>

            <v-divider></v-divider>

            <v-card-actions>
                <v-spacer></v-spacer>

                <v-btn
                        color="primary"
                        flat
                        @click="messageDialog = false">
                    CLOSE
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
    
</template>

<script>
    export default {
        name: "ShowMessagePopUp",
        props:{
            'selectedMessage' : Object,
            'dialog' : Boolean,
        },
        data: function () {
            return {
                messageDialog : this.dialog,
            }
        },
        watch:{
            messageDialog:function(){
                this.$emit('dialog',this.messageDialog);
            },
            dialog:function(){
                this.messageDialog=this.dialog;
            }
        },
        methods:{
            formatJson(message){
                if(message[0]==123||message[0]==91){
                    return JSON.stringify(JSON.parse(message),null,4);
                }
                else{
                    return message;
                }
            }
        }
    }
</script>
