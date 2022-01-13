<template>
  <div class="container">
    <div class="list-group list-group-flush">
      <div class="list-group-item">
        <div class="row">
          <div class="col-md-6">
            <img
              class="img-fluid"
              :src="car.image_url"
              :alt="car.title"
            />
          </div>
          <div class="col-md-6 text-left">
            <h3><b> {{car.brand_name}} </b> {{car.model_name}}</h3>
            <p>Reception date: {{car.delivery_date}}</p>
            <p>Delivery date: {{car.reception_date}}</p> 
              Day: {{car.day}}
            <p>{{car.price}} $ / per</p>
            <p>{{payment}}$</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'LeasedCarDetailSmall',
  props: {
    car: Object,
  },
  data(){
    return {
      payment: this.car.day * this.car.price
    }
  }
};
</script>
