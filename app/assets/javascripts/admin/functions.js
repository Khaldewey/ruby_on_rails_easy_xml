$(function() {
  $(".datetime").datetimepicker({})

  $('#images')
  .bind('cocoon:after-insert', function() {
    $(".date").datetimepicker({})
  })

  $('#nestable').nestable({})

  $('#image-sortable').nestable({
    maxDepth: 1
  })

  $('.nestable').on('change', function(){
    $.ajax({
      url: $(this).data('update-path'),
      type: 'POST',
      data:
        { nodes: $('.nestable').nestable('serialize') }
    })
  })

  $('.chosen-select').chosen(
    {no_results_text: "Oops, nenhum resultado encontrado!"}
  )

  $(":file").filestyle({
    classButton: "btn btn-default",
    buttonText: "Selecionar Arquivo",
    classInput: "form-control inline v-middle input-s"
  })

  $(".date").datetimepicker({
    format: 'DD/MM/YYYY',
    pickTime: false
  })

  $(".datetime").datetimepicker({
    format: 'DD/MM/YYYY hh:mm:ss',
    useSeconds: true,
  })

  if ($('.active').hasClass('item_menu')) {
    $('.active').parents('li').addClass('active')
  }

  $(".dropdown-toggle").click(function(){
    $(".dropdown-menu").slideToggle();
  });

  $("#phone_phone").inputmask("(99)[9]9999-9999").on("focusout", function () {
    var len = this.value.replace(/\D/g, '').length;
    $(this).inputmask(len > 10 ? "(99)[9]99999-9999" : "(99) 9999-9999");
  });

  $('[data-toggle="tooltip"]').tooltip();

  $('.simple-form button[type=submit].btn-primary').on('click', function (event) {  
    event.preventDefault();
    var el = $(this);
    el.prop('disabled', true);
    setTimeout(function(){el.prop('disabled', false); }, 3000);
  });  
  
  var options = {
    closeButton: true,
    debug: false,
    newestOnTop: false,
    progressBar: true,
    positionClass: "toast-top-center",
    preventDuplicates: true,
    onclick: null,
    showDuration: 300,
    hideDuration: 1000,
    timeOut: 3000,
    extendedTimeOut: 1000,
    showEasing: "swing",
    hideEasing: "linear",
    showMethod: "fadeIn",
    hideMethod: "fadeOut"
  }

  if($('.notice').text() !== "") 
    toastr.success($('.notice').text(), "Success!", options);  

  if($('.alert').text() !== "") 
    toastr.error($('.alert').text(), "Fail!", options); 
});
