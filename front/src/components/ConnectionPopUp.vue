<!--Connection PopUp-->
<template>
    <v-dialog
            v-model="connection"
            width="500"
            persistent>
        <template v-slot:activator="{ on }">

        </template>

        <v-card>
            <v-card-title  class="headline grey lighten-2"
                           primary-title>
                Connection
            </v-card-title>

            <br>

            <v-form @submit.prevent>
                <v-select solo
                          v-model="selectedUserGroup"
                          :items="userGroups"
                          item-text="name"
                          label="User Group"
                          class="strongTexts"
                          return-object
                ></v-select>

                <v-text-field v-model="host"
                              label="Host"
                              solo>
                </v-text-field>

                <v-text-field v-model="port"
                              label="Port"
                              solo>
                </v-text-field>

                <v-text-field v-model="username"
                              label="Username"
                              solo>
                </v-text-field>

                <v-text-field v-model="password"
                              label="Password"
                              solo
                              :type="'password'">
                </v-text-field>

                <v-card-actions>
                    <v-spacer></v-spacer>

                    <v-btn  type="submit"
                            color="primary"
                            flat
                            @click="connect()">
                        Connect
                    </v-btn>
                </v-card-actions>
            </v-form>



            <v-alert type="error"
                     v-model="connectionError">
                Error on connection
            </v-alert>
        </v-card>
    </v-dialog>
</template>

<script>
    import {connectMQTT} from '@/assets/js/Utils.js';
    export default {
        name: "ConnectionPopUp",
        props:{
            'connection' : Boolean,
            'userGroups' : Array,
        },
        data:function(){
            return {
                //Connexion variables
                username:'',
                password:'',
                port:'8000',
                host:'mqtt.rd.atosworldline.com',
                connectionModal: true,
                connectionError: false,
                selectedUserGroup : {
                    id:1,
                    isSelected:false,
                    name:'WLDD',
                },
            }
        },
        watch:{
            connectionModal:function(){
                this.$emit('connection',this.connectionModal);
            },
            selectedUserGroup:function(){
                this.$emit('selectedUserGroup',this.selectedUserGroup);
            }
        },
        methods:{
            //Permits to connect the user
            connect(){
                if(this.selectedUserGroup!=null){
                    connectMQTT(this.host,this.username,this.password,this.port,()=>{
                        this.connectionModal = false;
                        this.$parent.update();
                    },()=>{
                        this.connectionError = true;
                    })
                }
                else{
                    this.connectionError = true;
                }

            },
        }
    }
</script>

