<template>
  <div class="container text-left py-5">
    <div class="row">
      <div class="col-md-10">
        <form @submit.prevent="updateCar">
          <h2>Update a car</h2>
          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlTextarea1">
                  Price
                </label>
                <input class="form-control" type="text" v-model="price">
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="url"
                  >Image Url
                  <small class="text-muted">
                    Please include http://</small
                  ></label
                >
                <input
                  type="text"
                  class="form-control"
                  v-model="image_url"
                />
              </div>
              <br>
            </div>
            <div class="row">
              <div class="col-md-12 text-right">
                <button type="reset" class="btn btn-link mx-2 reset">
                  Reset
                </button>
                <button type="submit" class="btn btn-success submit">
                  Submit
                </button>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="col-md-2 info">
        <h6>Information </h6>
        <ul>
          <li>You can only change the image url and the price.</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'UpdateCar',
  data() {
    return {
      price: '',
      image_url: '',
      car: []
    };
  },
  
  methods: {
  updateCar() {
    axios.put(`http://localhost:5000/cars/${this.$route.params.id}`, {
      price: this.price,
      image_url: this.image_url
      })
      .then((response) => {
        if (response.status === 200) {
          this.car = response.data
          this.$router.push(`/car-list/${this.$route.params.id}`);
        }
      })
      .catch((err) => {
        if (err.response.status === 400) {
        alert("Failed! Please try again.");
        }
      });
    },
  }
};
</script>