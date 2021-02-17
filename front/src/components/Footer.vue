<template>
    <div class="Footer">
        <div color="rgb(46,46,64)"></div>
        <div class="strongTexts" id="version" >
            <span class="clickableFooter" @click="showChangeLogs=1">
                VERSION : 2.1 BETA
            </span>
        </div>

        <!--<a target="_blank" rel="noopener noreferrer"  href="https://drive.google.com/file/d/1Y3AdsPupiD-AXPBrjRSkUXJa8SD8o_Ev/view?usp=sharing">Documentation</a>-->

        <!--PopUp permitting to change parameters to the message to send-->
        <v-dialog
                v-model="showChangeLogs"
                width="500">
            <template v-slot:activator="{ on }">

            </template>

            <v-card>
                <v-card-title  class="headline grey lighten-2"
                               primary-title>
                    Changelogs
                </v-card-title>

                <v-card-text>
                    <div style="font-weight: bold">2.1</div>
                    -Les checkboxs sont pré-cochées lors de l'édition d'une démonstration
                    <div style="font-weight: bold">2.0</div>
                    -Ajout des fonctionnalités d'import et d'export d'action au format JSON
                    <br>
                    -Ajout de la possibilité de se désabonner d'un topic
                    <div style="font-weight: bold">1.9</div>
                    -Résolution du bug d'export de démonstration
                    <br>
                    -Les ids ne sont plus affichées à l'import d'une démonstration
                    <div style="font-weight: bold">1.8</div>
                    -Résolution du bug de popUp sur IOS
                    <br>
                    -Ajout de la persistence des valeurs par défaut à l'édition d'une action
                    <br>
                    -Ajouts de l'enregistrement de l'ID et de la date lors de la création et l'édition d'une action
                    <br>
                    <div style="font-weight: bold">1.6</div>
                    -Le formattage des tableaux de JSON est maintenant géré
                    <br>
                    -Résolution du bug des paramètres pour les topics à plusieurs paramètres
                    <div style="font-weight: bold">1.5</div>
                    -Ajout des fonctionnalités d'import et d'export de démonstration au format JSON
                    <br>
                    -Ajout de la persistance des valeurs pour les abonnements
                    <div style="font-weight: bold">1.4</div>
                    -Ajout de la possibilité de supprimer et d'éditer une démonstration
                    <br>
                    -Ajout d'un système de persistance des anciennes valeurs par défaut des paramètres
                    <br>
                    -L'affichage des messages gère les sous Json
                    <br>
                    -Réparation d'un bug d'encodage URI des paramètres
                    <br>
                    -Réparation d'un bug de formatage de JSON
                    <br>
                    -L'édition de paramètre se fait maintenant en une simple requête au lieu d'une par paramètre
                    <br>
                    <div style="font-weight: bold">1.3</div>
                    -Ajout d'une pop-up de confirmation a l'ajout d'une démonstration ou d'une action
                    <br>
                    -Réparation du bug des checkbox qui restent cochées après avoir changé de démonstration
                    <br>
                    -Ajout de la fonction submit au moment d'une édition
                    <br>
                    -Ajout de la possibilité de voir les topics auxquels on s'est abonné
                    <br>
                    -Ajout de la possibilité de voir le QoS d'un message et de savoir s'il est retained
                    <br>
                    -Réparation du bug d'affichage des topics et messages trop long dans l'inbox et dans la pop-up message
                    <br>
                    -Ajout d'un bouton Refresh dans le header de la page
                    <div style="font-weight: bold">1.2</div>
                    -Possibilité de changer l'ordre des actions affichées
                    <br>
                    -Ajout d'un bouton Cancel au Topic Subscribtion
                    <div style="font-weight: bold">1.1</div>
                    -Ajout des groupes utilisateurs pour filtrer les démonstrations affichées
                    <br>
                    -Possibilité de supprimer une action
                    <br>
                    -Possibilité d'éditer une action
                    <br>
                    -Possibilité de définir les valeurs par défaut des paramètres à la création de l'action
                    <br>
                    <div style="font-weight: bold">1.0</div>
                    -Import des démonstrations et des actions de la BDD
                    <br>
                    -Possibilité d'interagir avec le Broker MQTT (Publication/Réception)
                    <br>
                    -Possibilité de s'abonner à des topics
                    <br>
                    -Détection des paramètres des topics et des messages
                    <br>
                    -Possibilité d'ajouter des actions ou des démonstrations
                    <br>
                    -Affichage des messages reçus sur les topics auxquels on s'est abonné
                    <br>
                    -Possibilité d'afficher un message en format JSON
                    <br>
                    -Possibilité de vider l'inbox de réception de message
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>

                    <v-btn
                            color="primary"
                            flat
                            @click="showChangeLogs=0">
                        Close
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>

</template>

<script>

    export default {
        name: 'Footer',
        data:function(){
            return{
                showChangeLogs : 0,
            }
        },
    }

</script>
