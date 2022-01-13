<template>
  <div class="container">
    <div class="list-group list-group-flush">
      <div class="list-group-item">
        <div class="row">
          <div class="col-md-3">
            <img
              class="img-fluid"
              :src="car.image_url"
              :alt="car.title"
            />
          </div>
          <div class="col-md-6 text-left">
            <h3><b>{{car.brand_name}} {{car.model_name}} </b></h3>
            <h5> {{car.type}}</h5>
            <span>Fuel: {{car.fuel}}  Gear: {{car.gear}} Seat: {{car.seat}}</span>
            <p>{{car.price}} $ / per</p>
          </div>
          <div class="col-md-3">
            <button type="button" class="btn btn-primary" @click="goToDetail()">View More Details</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'CarDetail',
  props: {
    car: Object,
  },
  methods: {
    goToDetail() {
      this.$router.push(`/car-list/${this.car.car_id}`);
    },
  }
};
</script>
