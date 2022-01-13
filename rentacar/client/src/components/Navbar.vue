<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
      <router-link to="/" class="navbar-brand"
        ><b>RENT A CAR</b></router-link
      >
      <button
        class="navbar-toggler"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mb-2 mb-lg-0">
          <li class="nav-item">
            <router-link to="/" class="nav-link"
              >Home</router-link
            >
          </li>
          <li class="nav-item" v-show="isAdmin === 'true'">
            <router-link to="/leased" class="nav-link"
              >Leased Car</router-link
            >
          </li>
          <li class="nav-item">
            <router-link to="/car-list" class="nav-link"
              >Car List</router-link
            >
          </li>
          <li class="nav-item" v-show="isAdmin === 'true'">
            <router-link to="/create-car" class="nav-link"
              >Create A Car</router-link
            >
          </li>
          <li class="nav-item" v-show="isAdmin === 'true'">
            <router-link to="/admin-panel" class="nav-link"
              >Admin</router-link
            >
          </li>
          <li class="nav-item" v-show="isLogin === 'true'">
            <router-link to="/login" class="nav-link" @click="signOut"
              >Sign Out</router-link
            >
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'Navbar',
  data(){
    return{
      isAdmin: false,
      isLogin: false,
    }
  },
  mounted(){
    this.isAdmin = localStorage.getItem('isAdmin'),
    this.isLogin = localStorage.getItem('isLogin')
  },
  methods: {
    signOut() {
      this.İsLogin = false;
      this.isAdmin = false;
    }
  }
};
</script>

<style>
.navbar {
	height: 60px;
	padding: 0;
	max-height: 60px;
}
 .navbar .navbar-brand {
	font-size: 25px;
}
 .navbar .nav-item {
	font-size: 18px;
	margin-right: 40px;
}
 .navbar .btn {
	margin-right: 40px;
	width: 80px;
	height: 35px;
	border: 1px solid grey;
	color: grey;
	margin-top: 5px;
}
 .navbar .btn:hover {
	background-color: grey;
	color: white;
}
 .navbar .input {
	width: 300px;
	border-radius: 5px;
	border: 1px solid grey;
	margin-right: 10px;
	margin-top: 5px;
	height: 35px;
	padding: 10px;
}
 
</style>