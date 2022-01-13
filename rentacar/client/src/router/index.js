import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/leased',
    name: 'LeasedCar',
    component: () => import('../views/LeasedCarList.vue')
  },
  {
    path: '/car-list',
    name: 'Car List',
    component: () => import('../views/CarList.vue')
  },
  {
    path: '/create-car',
    name: 'CreateCar',
    component: () => import('../views/CreateCar.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue')
  },
  {
    path: '/admin-panel',
    name: 'AdminPanel',
    component: () => import('../views/AdminPanel.vue')
  },
  {
    path: '/car-list/:id',
    name: 'CarDetail',
    component: () => import('../views/CarDetail.vue'),
  },
  {
    path: '/update-car/:id',
    name: 'UpdateCar',
    component: () => import('../views/UpdateCar.vue'),
  },
  {
    path: '/rent/:id',
    name: 'RentCar',
    component: () => import('../views/Rent.vue'),
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
