<template>
  <div class="register">
    <div class="container">
      <div class="row m-5 no-gutters shadow-lg">
        <div class="col-md-6">
          <img src="https://images.unsplash.com/photo-1532616436807-d869032e09f1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80" class="img-fluid" />
        </div>
          <div class="col-md-6 bg-white p-5">
          <h3 class="pb-3">Register Form</h3>
          <div class="form-style">
            <form @submit.prevent="register">
              <div class="form-group pb-3">    
                <input type="text" placeholder="Name" class="form-control" v-model="first_name">   
              </div>
              <div class="form-group pb-3">    
                <input type="text" placeholder="Surname" class="form-control" v-model="last_name" >   
              </div>
              <div class="form-group pb-3">    
                <input type="email" placeholder="Email" class="form-control" v-model="mail" >   
              </div>
              <div class="form-group pb-3">   
                <input type="password" placeholder="Password" class="form-control" id="exampleInputPassword1" v-model="password">
              </div>
              <div class="pb-2">
              <button type="submit" class="btn btn-dark w-100 font-weight-bold mt-2" @click="register()">Submit</button>
              </div>
            </form>
            <div class="pt-4 text-center">
              Already have an account?  <a href="login">Login</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'Register',
  data() {
    return {
      first_name: '',
      last_name: '',
      mail: '',
      password: '',
      role_id: 2
    };
  },
  methods: {
    register() {
      axios.post('http://localhost:5000/register', {
        first_name: this.first_name,
        last_name: this.last_name,
        mail: this.mail,
        password: this.password,
        role_id: this.role_id,
      })
        .then((respose) => {
          if (respose.status === 200) {
            this.$router.push('/login');
          }

        })
        .catch((err) => {
          if (err.response.status === 400) {
            alert("Failed! Please try again.");
          }
      });
    },
  },
};
</script>

<style scoped>
body{
background: #c9ccd1; 
}
.register{
  width: 70%;
  margin-left: 15%;
}
.form-style input{
	border:0;
	height:50px;
	border-radius:0;
border-bottom:1px solid #ebebeb;	
}
.form-style input:focus{
border-bottom:1px solid #007bff;	
box-shadow:none;
outline:0;
background-color:#ebebeb;	
}
.sideline {
    display: flex;
    width: 10%;
    justify-content: center;
    align-items: center;
    text-align: center;
	color:#ccc;
}
button{
height:50px;	
}
.sideline:before,
.sideline:after {
    content: '';
    border-top: 1px solid #ebebeb;
    margin: 0 20px 0 0;
    flex: 1 0 20px;
}

.sideline:after {
    margin: 0 0 0 20px;
}
</style>