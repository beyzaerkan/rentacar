<template>
  <div class="login">
    <div class="container">
      <div class="row m-5 no-gutters shadow-lg">
        <div class="col-md-6">
          <img
            src="https://images.unsplash.com/photo-1588829274539-f346ce6dbde0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=327&q=80"
            class="img-fluid"
          />
        </div>
        <div class="col-md-6 bg-white p-5">
          <h3 class="pb-3">Login Form</h3>
          <div class="form-style">
            <form @submit.prevent="login">
              <div class="form-group pb-3">
                <input
                  type="email"
                  placeholder="Email"
                  class="form-control"
                  id="exampleInputEmail1"
                  aria-describedby="emailHelp"
                  v-model="mail"
                />
              </div>
              <div class="form-group pb-3">
                <input
                  type="password"
                  placeholder="Password"
                  class="form-control"
                  id="exampleInputPassword1"
                  v-model="password"
                />
              </div>
              <div class="d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center">
                  <input name="" type="checkbox" value="" />
                  <span class="pl-2 font-weight-bold">Remember Me</span>
                </div>
                <div><a href="#">Forget Password?</a></div>
              </div>
              <div class="pb-2">
                <button
                  type="submit"
                  class="btn btn-dark w-100 font-weight-bold mt-2"
                >
                  Submit
                </button>
              </div>
            </form>
            <div class="pt-4 text-center">
              Don't have an account yet? <a href="/register">Sign Up</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "Login",
  data() {
    return {
      mail: "",
      password: "",
      roles: [],
    };
  },
  methods: {
    login() {
      if (this.mail !== "" && this.password !== "") {
        axios
          .post("http://localhost:5000/login", {
            mail: this.mail,
            password: this.password,
          })
          .then((res) => {
            console.log(res.data);
            if (res.status === 200) {
              localStorage.setItem('isLogin', true);
              localStorage.setItem('userId', res.data.user_id)
              if (res.data.role_id === 2) {
                return this.$router.push("/");
              } else if (res.data.role_id === 1) {
                localStorage.setItem('isAdmin', true);
                return this.$router.push("/admin-panel");
              }
            }
            else 
              alert("User not found. Please try again");
          })
          .catch((err) => {
            console.error(err);
          });
      } else {
        console.log("Please enter all field");
      }
    },
  },
};
</script>

<style scoped>
body {
  background: #c9ccd1;
}
.login {
  width: 70%;
  margin-left: 15%;
}
.form-style input {
  border: 0;
  height: 50px;
  border-radius: 0;
  border-bottom: 1px solid #ebebeb;
}
.form-style input:focus {
  border-bottom: 1px solid #007bff;
  box-shadow: none;
  outline: 0;
  background-color: #ebebeb;
}
.sideline {
  display: flex;
  width: 10%;
  justify-content: center;
  align-items: center;
  text-align: center;
  color: #ccc;
}
button {
  height: 50px;
}
.sideline:before,
.sideline:after {
  content: "";
  border-top: 1px solid #ebebeb;
  margin: 0 20px 0 0;
  flex: 1 0 20px;
}

.sideline:after {
  margin: 0 0 0 20px;
}
</style>