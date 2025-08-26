try:
    from diffusers import DiffusionPipeline
    
    # 保存原始方法
    _old_from_pretrained = DiffusionPipeline.from_pretrained.__func__
    
    # 定义新的方法
    def _from_pretrained_with_cuda(cls, *args, **kwargs):
        pipe = _old_from_pretrained(cls, *args, **kwargs)
        return pipe.to("cuda:0")
    
    # 替换为 classmethod
    DiffusionPipeline.from_pretrained = classmethod(_from_pretrained_with_cuda)
except Exception as e:
    pass

