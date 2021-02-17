<template>
  <v-app>
    <Header></Header>
    <v-content>
      <v-container fluid grid-list-xl>
        <Body></Body>
      </v-container>
    </v-content>
    <Footer></Footer>
  </v-app>
</template>


<script>
  import Header from './components/Header'
  import Body from './components/Body'
  import Footer from './components/Footer'

  export default {
    name: 'App',
    components: {
      Header,
      Body,
      Footer
    },
  }

</script>