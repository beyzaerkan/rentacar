<template>
  <div class="home">
    <section>
    <div class="image  text-white ">
      <header>
        <div>
         <a href="/login" class="btn btn-outline-warning btn-lg active" role="button" aria-pressed="true" v-show="isLogin === false">Login</a>
        </div>
      </header>
    </div>
  </section>
  </div>
</template>

<script>
export default {
  name: 'Home',
  data(){
    return{
      isLogin: true
    }
  }
}
</script>

<style scoped>
.image{
  min-height: 100vh;
  background-image:linear-gradient(0deg,rgba(0,0,0,0.5),rgba(0,0,0,0.5)), url(https://images.unsplash.com/photo-1486496572940-2bb2341fdbdf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80);
  background-attachment: fixed;
  background-size: cover;
  background-position: center;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
