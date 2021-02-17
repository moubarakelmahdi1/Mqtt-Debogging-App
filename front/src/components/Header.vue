<template>
    <div class="banner">
        <div color="rgb(46,46,64)">
            <img src="@/assets/logo.png" alt="Logo wlddMQ" id="logo"/>
        </div>
    </div>

</template>

<script>

    export default {
        name: 'Header',
        methods: {
            reloadPage(){
                window.location.reload()
            },
        }
    }

</script>
