<template>
  <div id="app">
  <Navbar v-show="this.$route.path !=='/login'"/>
    <router-view/>
    <Footer v-show="this.$route.path !=='/login'"/>
  </div>
</template>

<script>
import Navbar from './components/Navbar.vue';
import Footer from './components/Footer.vue';
export default {
  name: 'App',
  components: {
    Navbar,
    Footer,
  },
  data(){
    return{
      isLogin: false,
    }
  },
  mounted(){
    this.isLogin = localStorage.getItem('isLogin');
    if(this.isLogin!=="true"){
      this.$router.push('/login');
    }
  }
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
