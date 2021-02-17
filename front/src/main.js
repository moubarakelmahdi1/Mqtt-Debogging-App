import Vue from 'vue'
import './plugins/vuetify'
import App from './App.vue'
import './assets/css/Custom.css'
import router from './router'



new Vue({
  router,
  render: h => h(App),
}).$mount('#app')

