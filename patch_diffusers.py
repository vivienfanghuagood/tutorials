try:
    from diffusers import DiffusionPipeline
    
    _old_from_pretrained = DiffusionPipeline.from_pretrained.__func__
    
    def _from_pretrained_with_cuda(cls, *args, **kwargs):
        pipe = _old_from_pretrained(cls, *args, **kwargs)
        return pipe.to("cuda")
    
    DiffusionPipeline.from_pretrained = classmethod(_from_pretrained_with_cuda)
except Exception as e:
    pass

