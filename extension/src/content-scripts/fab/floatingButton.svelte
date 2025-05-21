<script>
  import { onMount, onDestroy } from 'svelte';
  import { incrementBlogView } from '../firebase.js';
  export let url = '';
  export let title = '';
  export let region = 'kr';
  export let company = '';

  let hasRead = false;

  onMount(() => {
    window.addEventListener("scroll", handleScroll, { passive: true });
  });

  onDestroy(() => {
    window.removeEventListener("scroll", handleScroll);
  });

  function handleScroll() {
    let button = document.getElementById("floating-button");
    if(window.scrollY > 100){
      button.style.display = "flex";
    }else{
      button.style.display = "none";
    }

    if(window.scrollY/window.innerHeight > 0.8 && !hasRead){
      hasRead = true;
      incrementBlogView({
        url: url,
        title: title,
        region: region,
        company: company,
      });
    }
  }
  
  async function goToTop() {  
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

</script>

<div id="floating-button" class="floating-button-icon" on:click={goToTop}>
  <svg enable-background="new 0 0 24 24" height="512" viewBox="0 0 24 24" width="512" xmlns="http://www.w3.org/2000/svg"><g id="Layer_1"><path d="m12.499 22.5v-19.637l5.61 6.953c.173.215.488.248.703.074.216-.173.249-.488.075-.703l-6.431-7.97c-.02-.025-.182-.217-.457-.217-.276 0-.438.194-.458.219l-6.43 7.969c-.172.213-.138.53.075.702s.53.139.703-.074l5.61-6.953v19.637c0 .276.224.5.5.5s.5-.223.5-.5z"/></g></svg>
</div>

<style>
  .floating-button-icon {
    width: 40px;
    height: 40px;
    display: none;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background-color: #FFF;
    cursor: pointer;
    position: fixed;
    bottom: 20px;
    right: 20px;
    border: 1px solid #dadcdf;
    z-index: 1000;
    box-shadow: 0 0 0 1px #dadcdf, 0 4px 8px 0 rgba(0, 0, 0, .15);
  }

  .floating-button-icon svg {
    width: 24px;
    height: 24px;
    display: block;
  }

</style>