<template>
  <div class="container text-left py-3">
    <div class="row">
      <div class="col-md-10">
        <form @submit.prevent="rent">
          <h2>Rent a car</h2>

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlTextarea1">
                  Reception Date
                </label>
                <input class="form-control" type="date" v-model="reception_date">
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlTextarea1">
                  Delivery Date
                </label>
                <input class="form-control" type="date" v-model="delivery_date">
              </div>
            </div>
          </div> 

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlSelect1">City</label>
                <select
                  v-model="city_id"
                  class="form-control"
                  id="exampleFormControlSelect2"
                >
                  <option
                    v-for="city in cities"
                    :key="city.city_id"
                    v-bind:value="city.city_id"
                  >
                    {{ city.name }}
                  </option>
                </select>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlSelect1">Dealer Name</label>
                <select
                  v-model="dealer_id"
                  class="form-control"
                  id="exampleFormControlSelect2"
                >
                <option
                    v-for="dealer in cities.filter(
                      (b) => b.city_id == city_id
                    )[0].dealers"
                    :key="dealer.dealer_id"
                    v-bind:value="dealer.dealer_id"
                  >
                    {{ dealer.dealer_name }}
                  </option>
                </select>
              </div>
            </div>
          </div>

          <br>
          <div class="row">
            <div class="col-md-12 text-right">
              <button type="reset" class="btn btn-link mx-2 reset">
                Reset
              </button>
              <button type="submit" class="btn btn-success submit">
                Rent
              </button>
            </div>
          </div>
        </form>
      </div>

      <div class="col-md-2"> 
        <p>Price</p>
        <b>{{car.price}}</b>
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'axios'
export default {
  name: 'Rent',

  data (){
    return {
      cities: [],
      car: [],
      dealer_id: '',
      reception_date: '',
      delivery_date: '',
      car_id: '',
      day: '',
      city_id: 1,
      user_id: localStorage.getItem('userId'),
      price: ''
    }
  },
  mounted () {
    let car_id = new Number(this.$route.params.id)
    axios.get('http://localhost:5000/cities', {
    }).then((res) => {
      this.cities = res.data;
    });
    axios.get(`http://localhost:5000/cars/${car_id}`, {
    }).then((res) => {
      this.car = res.data;
    });
  },
  methods: {
    rent(){
      let car_id = new Number(this.$route.params.id)
      axios.post(`http://localhost:5000/rent/${car_id}`, {
          dealer_id: this.dealer_id,
          reception_date: this.reception_date,
          delivery_date: this.delivery_date,
          car_id,
          day: Math.round(Math.abs(new Date(this.delivery_date) - new Date(this.reception_date))/(1000 * 60 * 60 * 24)),
          city_id: this.city_id,
          user_id: this.user_id,
          rent_payment: Math.round(Math.abs(new Date(this.delivery_date) - new Date(this.reception_date))/(1000 * 60 * 60 * 24)) * this.car.price
        })
          .then((response) => {
            if (response.status === 200) {
              alert('Payment: ' + response.data.day * this.car.price + ' $');
              this.$router.push("/");
            }
          })
          .catch((err) => {
            if (err.response.status === 400) {
             alert("Failed! Please try again.");
            }
          });
    }   
  }
};
</script>
