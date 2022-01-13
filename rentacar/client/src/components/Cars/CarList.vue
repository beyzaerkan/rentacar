<template>
  <div class="p-5">
    <h1>Car Listing</h1>
      <CarDetail :car="car" v-for="car in cars" :key="car.id"/>
  </div>
</template>
<script>
import axios from 'axios';
import CarDetail from './CarDetailSmall.vue';
export default {
  name: 'CarList',
  components: {
    CarDetail
  },
  data() {
    return {
      cars: [],
    };
  },
  mounted() {
    axios.get('http://localhost:5000/cars', {
    }).then((res) => {
      this.cars = res.data;
      console.log(res.data);
    });
  },
};
</script>